# Virtio-GPU for Windows Guests

Windows guests require virtio-gpu drivers for proper display support.

## Installing virtio-gpu Drivers

1. Download the virtio-win ISO from https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/
2. Attach the ISO to the VM as a CD-ROM drive
3. In Windows Device Manager, update the display adapter driver
4. Browse to the virtio-win ISO and select the virtio-gpu driver

## Driver Location in virtio-win ISO

The virtio-gpu drivers are located in:
- `virtio-win.iso/virtio-gpu-win-*/` (for WDDM drivers)
- `virtio-win.iso/virtio-gpu-win-*/x64/` (for 64-bit systems)

## Verifying Installation

After installation, verify the driver is active:
1. Open Device Manager
2. Expand "Display adapters"
3. Confirm "Red Hat VirtIO GPU" is listed

## Troubleshooting

### Driver not detected
- Ensure the virtio-win ISO is attached and accessible in the guest
- In Device Manager, use "Update driver" → "Browse my computer" → point to the ISO's `virtio-gpu-win-*` directory
- Check that the VM is configured with `display: virtio` (not `none` or `vga`)

### Black screen after driver install
- Reboot the guest after installing/updating the driver
- If the screen remains black, boot into Safe Mode and roll back the display driver
- Verify the VM has at least 512 MB of RAM allocated

### Resolution issues
- Right-click desktop → Display Settings → check available resolutions
- If only low resolutions appear, the driver may not be loaded; verify in Device Manager
- For multiple monitors, ensure the virtio-win ISO version supports multi-head (v0.1.214+)

### Performance issues
- Enable 2D/3D acceleration in the VM configuration: `display: virtio` with `gl: true`
- Ensure the host has a modern GPU with up-to-date drivers
- Check that the guest is running a 64-bit version of Windows with the WDDM driver (not the older XDDM driver)
- Monitor GPU usage in Windows Task Manager under the "Performance" tab
