#!/bin/bash
# install_anarchy.sh - Installation script for Anarchy Inference and anarchy-agent

echo "=== Anarchy Inference & anarchy-agent Installation Script ==="
echo ""

# Create directories
echo "Creating directories..."
mkdir -p ~/anarchy-tools/bin
mkdir -p ~/anarchy-projects

# Download and install Anarchy Inference
echo "Downloading Anarchy Inference v0.3.1..."
wget -q https://github.com/APiTJLillo/Anarchy-Inference/releases/download/v0.3.1/anarchy-inference-v0.3.1-linux-x86_64.tar.gz
if [ $? -ne 0 ]; then
  echo "Error: Failed to download Anarchy Inference. Please check your internet connection."
  exit 1
fi

echo "Extracting Anarchy Inference binary..."
tar -xzf anarchy-inference-v0.3.1-linux-x86_64.tar.gz -C ~/anarchy-tools/bin
if [ $? -ne 0 ]; then
  echo "Error: Failed to extract Anarchy Inference binary."
  exit 1
fi

echo "Setting permissions..."
chmod +x ~/anarchy-tools/bin/anarchy-inference

# Add to PATH temporarily
export PATH="$HOME/anarchy-tools/bin:$PATH"

# Verify installation
echo "Verifying Anarchy Inference installation..."
if command -v anarchy-inference &> /dev/null; then
  echo "✓ Anarchy Inference installed successfully!"
else
  echo "Error: Anarchy Inference installation failed. The binary is not in PATH."
  exit 1
fi

# Clone anarchy-agent repository
echo "Cloning anarchy-agent repository..."
cd ~/anarchy-projects
git clone https://github.com/APiTJLillo/anarchy-agent.git
if [ $? -ne 0 ]; then
  echo "Error: Failed to clone anarchy-agent repository."
  exit 1
fi

echo "Setting up anarchy-agent project structure..."
cd anarchy-agent
mkdir -p src/memory/enhanced
mkdir -p src/llm
mkdir -p src/reasoning
mkdir -p src/tools
mkdir -p src/integration
mkdir -p examples_ai/enhanced
mkdir -p tests/enhanced

# Create a simple test file
echo "Creating test file..."
cat > hello_anarchy.a.i << 'EOF'
// hello_anarchy.a.i - Simple test for anarchy-agent

// Define a simple greeting function
🔠 greet(name) {
  📤 "Hello, " + name + "! Your anarchy-agent setup is working correctly."
}

// Main execution
📝 "=== Anarchy Agent Test ==="
📝 greet("User")
📝 "If you see this message, everything is set up correctly!"
EOF

echo ""
echo "=== Installation Complete! ==="
echo ""
echo "To use Anarchy Inference permanently, add this line to your ~/.bashrc or ~/.zshrc file:"
echo "  export PATH=\"\$HOME/anarchy-tools/bin:\$PATH\""
echo ""
echo "To test your installation, run:"
echo "  cd ~/anarchy-projects/anarchy-agent"
echo "  anarchy-inference hello_anarchy.a.i"
echo ""
echo "For more information, see the LOCAL_DEPLOYMENT_GUIDE.md file."
