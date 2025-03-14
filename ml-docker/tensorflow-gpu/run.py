import tensorflow as tf
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import os
import time
import random

# Step 1: Configure TensorFlow to use GPU 2
#gpus = tf.config.list_physical_devices('GPU')
#tf.config.set_visible_devices(gpus[0], 'GPU')

# Load the frozen model graph
def load_graph(pb_file):
    with tf.io.gfile.GFile(pb_file, "rb") as f:
        graph_def = tf.compat.v1.GraphDef()
        graph_def.ParseFromString(f.read())
        
    # Import the graph into the default graph
    with tf.compat.v1.Session() as sess:
        tf.compat.v1.import_graph_def(graph_def, name="")
        return sess.graph

# Path to your .pb file (Inception V1 frozen model)
model_path = "inception_v1_inference.pb"  # Update this to your actual file path

# Load the model
graph = load_graph(model_path)

# Start a TensorFlow session
with tf.compat.v1.Session(graph=graph) as sess:
    # Get input and output tensor names (replace with actual names from your model)
    input_tensor = graph.get_tensor_by_name("input:0")  # Replace 'input' with your actual input tensor name
    output_tensor = graph.get_tensor_by_name("InceptionV1/Logits/Predictions/Reshape_1:0")  # Replace 'output' with actual output name
    
    # Load and preprocess an image
    def preprocess_image(image_path):
        image = Image.open(image_path).convert("RGB")
        image = image.resize((224, 224))  # Resize to 224x224
        image = np.array(image) / 255.0  # Normalize to [0, 1]
        image = (image - 0.5) * 2  # Normalize to [-1, 1]
        image = np.expand_dims(image, axis=0)  # Add batch dimension
        return image

    start_time = time.time()
    image_file_prefix = "./data/ILSVRC2012_val_"
    image_file_suffix = ".JPEG"

    print("Scaning 100 images:")
    start_measure = time.perf_counter()
    processed_images = 0

    # Run for 10 seconds
    for i in range(1,101):
        # We have a total of 500 images, we randomly select an image
        image_id = str(i)
        image_path = image_file_prefix+('0'*(8-len(image_id)))+image_id+image_file_suffix
    
        # Preprocess image
        image_array = preprocess_image(image_path)
        # Run inference
        predictions = sess.run(output_tensor, feed_dict={input_tensor: image_array})
        # Print predictions (feature vector or class probabilities depending on model)
        # print("Predictions:", predictions)
        processed_images += 1
    
    end_measure = time.perf_counter()

    elapsed_time_s = end_measure - start_measure
    throughput = processed_images / elapsed_time_s

    print(f"Elapsed time: {elapsed_time_s:.4f}s")
    print(f"Total processed images: {processed_images}")
    print(f"Inference throughput: {throughput:.4f} images/s")
    latency = elapsed_time_s/processed_images*1000
    print(f"Inference latency: {latency:.4f} ms")

