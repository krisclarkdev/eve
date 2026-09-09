# SPICE Client Usage Guide

EVE uses the SPICE (Simple Protocol for Independent Computing Environments) protocol for remote display access to guest VMs. SPICE provides superior performance compared to VNC, especially for hardware-accelerated graphics.

## Why SPICE over VNC?

SPICE offers several advantages over traditional VNC:

- **Better performance:** Optimized for remote desktop use with lower latency
- **Hardware acceleration support:** Works with virtio-gpu for GPU-accelerated display
- **Dynamic resolution:** Automatically adapts to client window size
- **Multimedia redirection:** Efficient audio/video streaming
- **Clipboard sharing:** Bidirectional clipboard between host and guest

## Default SPICE Port

The default SPICE port is **5900** (TCP). Each VM instance uses a sequential port starting from 5900.

## Recommended SPICE Clients

### Linux

The standard Linux SPICE client is `remote-viewer` (part of the `virt-viewer` package):

```bash
# Debian/Ubuntu
sudo apt install virt-viewer

# RHEL/CentOS/Fedora
sudo dnf install virt-viewer

# Arch Linux
sudo pacman -S virt-viewer
```

### Windows

Download the SPICE client from the official website:
[https://www.spice-space.org/download.html](https://www.spice-space.org/download.html)

### macOS

Download the SPICE client from the official website:
[https://www.spice-space.org/download.html](https://www.spice-space.org/download.html)

### Browser-based Access

For browser-based access, EVE includes a Guacamole server that provides SPICE connectivity through any modern web browser. This is the default access method and requires no additional client installation.

## Connecting to EVE VMs

### Using remote-viewer (Linux)

```bash
# Basic connection
remote-viewer spice://<host>:5900

# With password
remote-viewer spice://<host>:5900?password=<password>

# With TLS
remote-viewer spice://<host>:5900?tls-port=5901&password=<password>
```

### Using SPICE Web

Navigate to the EVE web UI and click on the VM's display button to open a browser-based SPICE session through Guacamole.

### SPICE URL Format

The standard SPICE URL format is:

```
spice://<host>:<port>?password=<password>
```

Where:
- `<host>` is the EVE device IP address or hostname
- `<port>` is the SPICE port (default: 5900)
- `<password>` is the VM display password (optional)

## Security Considerations

### Password Protection

EVE uses password-protected SPICE connections by default. The password is configured per-VM through the VM configuration.

### TLS/SSL

For encrypted connections, SPICE supports TLS:

```bash
remote-viewer spice://<host>:5900?tls-port=5901&password=<password>
```

### Network Isolation

For production deployments, consider:

- Restricting SPICE port access to trusted networks using firewall rules
- Using SSH tunneling for additional security:
  ```bash
  ssh -L 5900:localhost:5900 <host>
  remote-viewer spice://localhost:5900
  ```
- Enabling TLS for encrypted traffic

### Port Forwarding

To allow external access to SPICE ports, set the global configuration option `app.allow.vnc` to `true`. By default, only local access is allowed.

## Troubleshooting

### Connection refused

- Verify the SPICE port is open and accessible
- Check that the VM is running and display is enabled
- Ensure `app.allow.vnc` is set to `true` for external access

### No display

- Confirm the VM has display enabled (`EnableVnc` flag in EdgeAppConfig)
- Check that the SPICE port matches the VM instance
- Try refreshing the connection

### Performance issues

- Ensure virtio-gpu drivers are installed in the guest
- Use SPICE client instead of browser for better performance
- Check network latency between client and EVE device
