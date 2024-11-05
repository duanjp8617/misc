import pickle
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import DataLoader, Dataset
from torchvision import transforms, models

# Define a custom Dataset to load CIFAR-10 from the extracted files
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

# Specify the paths to the data files
data_dir = "/workspace/data"
train_files = [f"{data_dir}/data_batch_{i}" for i in range(1, 6)]
test_files = [f"{data_dir}/test_batch"]

# Create datasets and data loaders
train_dataset = CIFAR10Dataset(train_files, transform=transform)
test_dataset = CIFAR10Dataset(test_files, transform=transform)

train_loader = DataLoader(train_dataset, batch_size=64, shuffle=True, num_workers=2)
test_loader = DataLoader(test_dataset, batch_size=64, shuffle=False, num_workers=2)

# Define the model (ResNet-50)
model = models.resnet50(pretrained=False)
model.fc = nn.Linear(model.fc.in_features, 10)  # Modify the output layer for 10 CIFAR-10 classes
model = model.to('cpu')  # Ensure the model is on CPU

# Define the loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)

# Training function
def train(model, train_loader, criterion, optimizer, epochs=5):
    model.train()  # Set model to training mode
    for epoch in range(epochs):
        running_loss = 0.0
        for i, (inputs, labels) in enumerate(train_loader):
            # Move data to CPU
            inputs, labels = inputs.to('cpu'), labels.to('cpu')

            # Zero the parameter gradients
            optimizer.zero_grad()

            # Forward pass
            outputs = model(inputs)
            loss = criterion(outputs, labels)

            # Backward pass and optimize
            loss.backward()
            optimizer.step()

            running_loss += loss.item()
            if i % 100 == 99:  # Print every 100 batches
                print(f"Epoch [{epoch+1}/{epochs}], Batch [{i+1}/{len(train_loader)}], Loss: {running_loss / 100:.4f}")
                running_loss = 0.0

# Evaluation function
def evaluate(model, test_loader, criterion):
    model.eval()  # Set model to evaluation mode
    correct = 0
    total = 0
    test_loss = 0.0

    with torch.no_grad():
        for inputs, labels in test_loader:
            # Move data to CPU
            inputs, labels = inputs.to('cpu'), labels.to('cpu')

            # Forward pass
            outputs = model(inputs)
            loss = criterion(outputs, labels)
            test_loss += loss.item()

            # Calculate accuracy
            _, predicted = torch.max(outputs, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()

    accuracy = 100 * correct / total
    print(f"Test Loss: {test_loss / len(test_loader):.4f}, Accuracy: {accuracy:.2f}%")

# Train and evaluate the model
epochs = 5
train(model, train_loader, criterion, optimizer, epochs)
evaluate(model, test_loader, criterion)

