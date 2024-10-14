import os
import random
import subprocess

# Check if the plugin.txt file exists
if not os.path.isfile("plugin.txt"):
    print("File plugin.txt not found!")
    exit(1)

# Create the extracted_plugins directory if it doesn't exist
os.makedirs("extracted_plugins", exist_ok=True)

# Extract plugin names from plugin.txt
with open("plugin.txt", "r") as file:
    plugin_names = [line.strip() for line in file.readlines() if line.strip()]

# Ensure we do not attempt to sample more plugins than available
num_plugins_to_select = min(5000, len(plugin_names))
selected_plugins = random.sample(plugin_names, num_plugins_to_select)

# Navigate to the extracted_plugins directory
os.chdir("extracted_plugins")

# Process each selected plugin
for plugin_name in selected_plugins:
    svn_url = f"https://plugins.svn.wordpress.org/{plugin_name}/trunk/"
    
    # Create a directory for the plugin if it doesn't exist
    os.makedirs(plugin_name, exist_ok=True)
    
    # Navigate to the plugin directory
    os.chdir(plugin_name)
    
    try:
        # Checkout the latest version from the SVN repository
        result = subprocess.run(["svn", "checkout", svn_url, "."], capture_output=True, text=True)
        if result.returncode != 0:
            print(f"Failed to download {plugin_name}: {result.stderr}")
        else:
            print(f"Downloaded the latest version of {plugin_name} to {os.getcwd()}")
    except Exception as e:
        print(f"An unexpected error occurred while downloading {plugin_name}: {str(e)}")
    
    # Navigate back to the extracted_plugins directory
    os.chdir("..")
