## Linux Utility to Update Linux-Based Applications with Over-The-Air (OTA) Updates

This utility allows you to perform **Over The Air (OTA) programming** on Linux systems. I am using this to update a set of Raspberry Pis, which monitor various features in my apartment, greenhouse garden, and file server, with the latest application. It facilitates the downloading and installation of the latest versions of applications, libraries, and configurations over the HTTP protocol.

This utility is fully written in **bash**.

## How to Install

```bash
./install.sh
```

This will add the OTA updater daemon (`ota.monitor`) to the startup script, ensuring that it starts and runs on every reboot. The script will be added to `rc.local` to make sure it is executed automatically.

## Server File Structure

To facilitate OTA updates, your server should have the following file structure:

```
/downloads
    ├── cfg_ver.txt        # Configuration version file
    ├── sw_ver.txt         # Software version file
    ├── sw.tar.gz          # Software update package
    └── config.xml         # Configuration file
```

### Files and Their Purpose

1. **cfg_ver.txt**: 
   - This file holds the current version identifier of the configuration file.
   - **Content**: A string or number representing the configuration version (e.g., `1.0`, `2.1`).

   **Example:**
   ```
   1.0
   ```

2. **sw_ver.txt**: 
   - This file holds the current version identifier of the software package.
   - **Content**: A string or number representing the software version (e.g., `1.0.0`, `2.0.1`).

   **Example:**
   ```
   1.0.0
   ```

3. **sw.tar.gz**: 
   - This is a compressed tarball (GZipped) containing the updated software files that need to be installed on the target system.
   - The contents of this file should be the application files or libraries necessary for the updated software.

   **Example Contents**:
   - `bin/`
     - `app_name`
   - `lib/`
     - `lib_name.so`

4. **config.xml**:
   - This XML file contains the configuration settings for the application. It can be customized based on the software requirements.
   - The format of this file should adhere to the specific requirements of your application.
   
   **Example:**
   ```xml
   <configuration>
       <setting name="max_connections" value="100"/>
       <setting name="timeout" value="30"/>
   </configuration>
   ```

---

## Workflow Overview

### 1. **Initial Setup**

When the OTA utility runs on the client machine, it will check the version files (`cfg_ver.txt` and `sw_ver.txt`) hosted on your server. The utility will then compare these versions with the locally stored version files. If a newer version is available, it will download the updated software and configuration files.

### 2. **Version File Update**

The version files (`cfg_ver.txt` and `sw_ver.txt`) are simple text files that contain the version numbers of the configuration and software. When you release new updates, you must:

1. Update the version numbers in `cfg_ver.txt` and `sw_ver.txt`.
2. Upload the new software tarball (`sw.tar.gz`) and configuration file (`config.xml`) to the server.

### 3. **Software File (sw.tar.gz)**

The `sw.tar.gz` file should contain the updated application, libraries, or any other files necessary to update the system. The OTA utility will download this file and extract its contents to the appropriate directory on the target system.

### 4. **Configuration File (config.xml)**

The `config.xml` file should include any configuration settings needed by your software. These settings will be downloaded and replaced by the utility on the target machine.

---

## Example Server Configuration

Here’s an example of how your server files might look:

```
/downloads
    ├── cfg_ver.txt        -> "1.0"
    ├── sw_ver.txt         -> "1.0.0"
    ├── sw.tar.gz          -> [The tarball containing the software update]
    └── config.xml         -> [The configuration file in XML format]
```

When the utility runs, it will:

1. Download the `cfg_ver.txt` and `sw_ver.txt` files.
2. Compare the versions with the locally stored version files.
3. If a new version is found, it will download and install the new software from `sw.tar.gz` and the configuration from `config.xml`.
4. The system will then reboot to apply the updates.

---

## Hosting on the Server

- Ensure the files are accessible over HTTP.
- You can host the files on any web server (e.g., Apache, Nginx).
- The URL provided in the script (e.g., `http://viki.design/downloads`) should point to the location where these files are hosted.

---

## Notes

- Ensure that the `sw.tar.gz` file is valid and contains the correct software files.
- Update the `cfg_ver.txt` and `sw_ver.txt` files each time you release a new version of the software or configuration.
- If the OTA process fails, the utility will attempt to restore the previous working versions of the software and configuration.

