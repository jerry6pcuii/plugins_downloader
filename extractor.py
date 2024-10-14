import os
import random
import subprocess

# Check if the plugin.txt file exists
if not os.path.isfile("plugin.txt"):
    print("File plugin.txt not found!")
    exit(1)

# Create the extracted_plugins directory if it doesn't exist
os.makedirs("extracted_plugins", exist_ok=True)

# Extract 3000 random plugin names from plugin.txt
with open("plugin.txt", "r") as file:
    plugin_names = file.readlines()

# Randomly select 3 plugin names
selected_plugins = random.sample(plugin_names, 19394)

# Navigate to the extracted_plugins directory
os.chdir("extracted_plugins")

# Process each selected plugin
for plugin_name in selected_plugins:
    plugin_name = plugin_name.strip()  # Remove any extra spaces or newlines
    svn_url = f"https://plugins.svn.wordpress.org/{plugin_name}/trunk/"
    
    # Create a directory for the plugin if it doesn't exist
    os.makedirs(plugin_name, exist_ok=True)
    
    # Navigate to the plugin directory
    os.chdir(plugin_name)
    
    # Checkout the latest version from the SVN repository
    subprocess.run(["svn", "checkout", svn_url, "."], check=True)
    
    print(f"Downloaded the latest version of {plugin_name} to {os.getcwd()}")
    
    # Navigate back to the extracted_plugins directory
    os.chdir("..")
