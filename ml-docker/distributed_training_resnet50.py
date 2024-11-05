import pickle
import numpy as np
import os
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from torchvision import datasets, transforms, models
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP

# Set up Distributed Training
def setup(rank, world_size):
    os.environ['MASTER_ADDR'] = '192.168.150.142'  # Change to main node IP
    os.environ['MASTER_PORT'] = '12355'      # Change to an available port
    dist.init_process_group("gloo", rank=rank, world_size=world_size)

# Clean up Distributed Training
def cleanup():
    dist.destroy_process_group()

# Custom CIFAR-10 Dataset if loading manually
class CIFAR10Dataset(Dataset):
    def __init__(self, data_files, transform=None):
        self.data, self.labels = self.load_data(data_files)
        self.transform = transform

    def load_data(self, files):
        data = []
        labels = []
        for file in files:
            with open(file, 'rb') as f:
                batch = pickle.load(f, encoding='bytes')
                data.append(batch[b'data'])
                labels.extend(batch[b'labels'])
        data = np.concatenate(data).reshape(-1, 3, 32, 32)  # Reshape to (N, C, H, W)
        data = data.transpose(0, 2, 3, 1)  # Convert to (N, H, W, C)
        return data, labels

    def __len__(self):
        return len(self.labels)

    def __getitem__(self, idx):
        image = self.data[idx]
        label = self.labels[idx]
        if self.transform:
            image = self.transform(image)
        return image, label

# Define transformations for the CIFAR-10 images
transform = transforms.Compose([
    transforms.ToPILImage(),
    transforms.ToTensor(),
    transforms.Normalize((0.5, 0.5, 0.5), (0.5, 0.5, 0.5)),
])

# Training function
def train(rank, world_size, epochs=5):
    setup(rank, world_size)
    
    # Load CIFAR-10 dataset from local extracted files
    data_dir = "/workspace/data"  # Update with your actual path
    train_files = [f"{data_dir}/data_batch_{i}" for i in range(1, 6)]
    test_files = [f"{data_dir}/test_batch"]

    train_dataset = CIFAR10Dataset(train_files, transform=transform)
    test_dataset = CIFAR10Dataset(test_files, transform=transform)

    # Create a DistributedSampler for each process
    train_sampler = torch.utils.data.distributed.DistributedSampler(
        train_dataset,
        num_replicas=world_size,
        rank=rank
    )

    train_loader = DataLoader(train_dataset, batch_size=64, shuffle=False, num_workers=2, sampler=train_sampler)
    test_loader = DataLoader(test_dataset, batch_size=64, shuffle=False, num_workers=2)

    # Define the model and wrap it with DDP
    model = models.resnet50(pretrained=False)
    model.fc = nn.Linear(model.fc.in_features, 10)  # Modify the output layer for CIFAR-10 classes
    model = model.to('cpu')
    model = DDP(model, device_ids=None)  # device_ids=None ensures CPU-only training

    # Loss function and optimizer
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)

    # Training loop
    model.train()
    for epoch in range(epochs):
        train_sampler.set_epoch(epoch)  # Shuffle data between epochs
        running_loss = 0.0
        for i, (inputs, labels) in enumerate(train_loader):
            # Move data to CPU
            inputs, labels = inputs.to('cpu'), labels.to('cpu')

            # Zero the parameter gradients
            optimizer.zero_grad()

            # Forward pass
            outputs = model(inputs)
            loss = criterion(outputs, labels)

            # Backward pass and optimization
            loss.backward()
            optimizer.step()

            running_loss += loss.item()
            if i % 100 == 99:
                print(f"Rank {rank}, Epoch [{epoch+1}/{epochs}], Batch [{i+1}/{len(train_loader)}], Loss: {running_loss / 100:.4f}")
                running_loss = 0.0

    cleanup()

if __name__ == "__main__":
    # Set world size to 3 (total machines) and specify rank based on the machine
    world_size = 2
    rank = int(os.environ['RANK'])  # Unique rank for each node

    # Number of epochs
    epochs = 5
    train(rank, world_size, epochs)
