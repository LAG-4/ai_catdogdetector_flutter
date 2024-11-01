# Cat and Dog Detector

This is a simple Flutter application that uses AI to detect whether an uploaded image is of a cat or a dog. This project was created as a learning and testing project to explore image classification with machine learning models in Flutter.

## Demo

<p align="center">
  <img src="https://drive.google.com/file/d/1LKAraRnpm-whEzC7GQUmQl-rGj-i3esm/view?usp=sharing" alt="App Demo" width="250">
    <img src="https://drive.google.com/file/d/1W4m8w7DCveuVjxX3zFdAONRY1KYL8hUB/view?usp=sharing" alt="App Demo" width="250">
</p>

## Features

- Upload an image of a cat or dog.
- Uses a machine learning model to classify the image as either a cat or a dog.
- Real-time prediction powered by a TensorFlow Lite model.
  
## How It Works

1. **Dataset**: The dataset used for training was downloaded from Kaggle. You can find the dataset [here](https://www.kaggle.com/datasets/tongpython/cat-and-dog?resource=download).
2. **Model Training**: I used [Teachable Machine](https://teachablemachine.withgoogle.com/train) to train a custom image classification model. Teachable Machine makes it simple to build and export a model trained on images without requiring in-depth ML expertise.
3. **Flutter and TensorFlow Lite**: The model from Teachable Machine was exported as a TensorFlow Lite model, which was integrated into the Flutter application. I used TensorFlow Lite packages for loading the model and running inference on device.

## Libraries and Dependencies

- **Flutter**: The core framework for building the app.
- **TensorFlow Lite**: Used for running the machine learning model on mobile devices.
- **Image Picker**: For selecting images from the device's gallery or camera.
- **Path Provider**: To find commonly used locations on the filesystem.
- **HTTP**: For making network requests if needed in the future.
  
