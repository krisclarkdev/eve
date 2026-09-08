# Implementation Plan: FR201 VM HDMI Passthrough

## Overview

Enable direct HDMI display output from VMs running on EVE-OS on the OnLogic FR201 (Raspberry Pi CM4) by exposing the vc4/v3d GPU via virtio-gpu with DRM/KMS backend.

## Prerequisites

- EVE-OS source code
- FR201 hardware (or RPi4/CM4 equivalent)
- QEMU built with DRM/KMS support
- Guest OS with virtio-gpu driver

## Phase 1: Research & Design

### 1.1 Investigate QEMU virtio-gpu DRM backend
- [ ] Review QEMU source for virtio-gpu DRM backend implementation
- [ ] Determine if vc4 GPU is supported out of the box
- [ ] Identify required QEMU patches for vc4 support

### 1.2 Investigate EVE-OS hypervisor integration
- [ ] Review EVE's KVM hypervisor configuration (pkg/pillar/hypervisor/kvm.go)
- [ ] Review EVE's Xen hypervisor configuration (pkg/pillar/hypervisor/xen.go)
- [ ] Determine how to add virtio-gpu device to VM configuration

### 1.3 Design implementation approach
- [ ] Decide on KVM vs Xen for initial implementation
- [ ] Design VM configuration schema for GPU passthrough
- [ ] Document required changes

## Phase 2: QEMU Modifications

### 2.1 Build QEMU with DRM/KMS support
- [ ] Configure QEMU build with `--enable-drm`
- [ ] Verify vc4 DRM backend is available

### 2.2 Test virtio-gpu with vc4 DRM backend
- [ ] Create test VM configuration with virtio-gpu
- [ ] Test on RPi4/CM4 hardware
- [ ] Verify HDMI output from VM

### 2.3 Develop QEMU patches (if needed)
- [ ] Identify required patches for vc4 support
- [ ] Develop and test patches
- [ ] Submit patches to QEMU upstream (optional)

## Phase 3: EVE-OS Integration

### 3.1 Update KVM hypervisor configuration
- [ ] Modify pkg/pillar/hypervisor/kvm.go to support virtio-gpu
- [ ] Add VM configuration option for GPU passthrough
- [ ] Implement device tree overlay for vc4 GPU (if needed)

### 3.2 Update Xen hypervisor configuration
- [ ] Modify pkg/pillar/hypervisor/xen.go to support virtio-gpu
- [ ] Add VM configuration option for GPU passthrough
- [ ] Implement Xen PV framebuffer support (if needed)

### 3.3 Update FR201 device model
- [ ] Add GPU adapter to models/OnLogic.FR201.json
- [ ] Define CDI string for vc4 GPU
- [ ] Document GPU passthrough configuration

## Phase 4: Testing

### 4.1 Unit tests
- [ ] Write unit tests for KVM hypervisor changes
- [ ] Write unit tests for Xen hypervisor changes
- [ ] Run existing test suite to verify no regressions

### 4.2 Integration tests
- [ ] Deploy test VM with virtio-gpu on FR201
- [ ] Verify HDMI output from VM
- [ ] Test with different guest OSes (Linux, Windows)

### 4.3 Performance tests
- [ ] Measure display latency
- [ ] Measure GPU utilization
- [ ] Compare with container CDI approach

## Phase 5: Documentation

### 5.1 User documentation
- [ ] Update EVE-OS documentation with GPU passthrough instructions
- [ ] Document VM configuration for GPU passthrough
- [ ] Document troubleshooting steps

### 5.2 Developer documentation
- [ ] Update developer documentation with implementation details
- [ ] Document QEMU patches and modifications
- [ ] Document testing procedures

## Phase 6: Release

### 6.1 Code review
- [ ] Submit changes for code review
- [ ] Address review comments
- [ ] Merge changes to main branch

### 6.2 Release notes
- [ ] Update release notes with GPU passthrough feature
- [ ] Document known issues and limitations
- [ ] Announce feature to community

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| QEMU virtio-gpu DRM backend doesn't support vc4 | High | Develop QEMU patches; fallback to Xen PV framebuffer |
| Guest OS virtio-gpu driver doesn't support DRM | Medium | Test with multiple guest OSes; document requirements |
| HDMI output requires additional configuration | Low | Document configuration steps; provide examples |
| Performance issues with virtio-gpu | Medium | Optimize QEMU configuration; benchmark and tune |

## Timeline

- Phase 1: 1 week
- Phase 2: 2 weeks
- Phase 3: 2 weeks
- Phase 4: 1 week
- Phase 5: 1 week
- Phase 6: 1 week

**Total: 8 weeks**

## Success Criteria

- VM can display on HDMI output via virtio-gpu
- No regressions in existing EVE-OS functionality
- Documentation is complete and accurate
- Code is reviewed and merged to main branch