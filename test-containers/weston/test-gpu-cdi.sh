#!/bin/bash
# EVE-OS FR201 GPU CDI Test Script
# Tests vc4/v3d GPU passthrough to container via CDI

set -e

FR201_IP="${1:-192.168.1.100}"
FR201_USER="${2:-eve}"
FR201_PASS="${3:-eve}"

echo "=== EVE-OS FR201 GPU CDI Test ==="
echo "Target: ${FR201_IP}"
echo ""

# Step 1: Verify FR201 is reachable
echo "[1/6] Checking FR201 connectivity..."
if ! ping -c 2 -W 2 "${FR201_IP}" > /dev/null 2>&1; then
    echo "ERROR: FR201 not reachable at ${FR201_IP}"
    exit 1
fi
echo "OK: FR201 reachable"

# Step 2: Upload CDI file
echo "[2/6] Uploading CDI file..."
scp -o StrictHostKeyChecking=no eve/pkg/rpi/cdi/rpi-cm4.yaml \
    "${FR201_USER}@${FR201_IP}:/etc/cdi/rpi-cm4.yaml"
echo "OK: CDI file uploaded"

# Step 3: Upload model file
echo "[3/6] Uploading device model..."
scp -o StrictHostKeyChecking=no eve/models/OnLogic.FR201.json \
    "${FR201_USER}@${FR201_IP}:/tmp/OnLogic.FR201.json"
echo "OK: Model file uploaded"

# Step 4: Apply model via zcli
echo "[4/6] Applying device model..."
ssh -o StrictHostKeyChecking=no "${FR201_USER}@${FR201_IP}" \
    "zcli model apply /tmp/OnLogic.FR201.json"
echo "OK: Model applied"

# Step 5: Deploy weston container with GPU adapter
echo "[5/6] Deploying weston container with GPU..."
ssh -o StrictHostKeyChecking=no "${FR201_USER}@${FR201_IP}" \
    "zcli app deploy eve-weston:latest --adapter GPU0 --name gpu-test"
echo "OK: Container deployed"

# Step 6: Verify container is running
echo "[6/6] Verifying container status..."
sleep 10
ssh -o StrictHostKeyChecking=no "${FR201_USER}@${FR201_IP}" \
    "zcli app list | grep gpu-test"

echo ""
echo "=== Test Complete ==="
echo "Check HDMI output for weston desktop."
echo "To clean up: zcli app undeploy gpu-test"