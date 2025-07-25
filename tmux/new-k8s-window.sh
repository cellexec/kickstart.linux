#!/bin/bash

SESSION="$1"
WINDOW_INDEX=1  # second window created by tmux

# Rename window 1 to "K8S"
tmux rename-window -t "${SESSION}:${WINDOW_INDEX}" "󱃾"

# Split it left/right
tmux split-window -h -t "${SESSION}:${WINDOW_INDEX}.0"

# SSH into cluster.prod and run k9s
tmux send-keys -t "${SESSION}:󱃾.0" "ssh cluster.prod -t 'zsh -ilc \"export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && ~/projects/kickstart.linux/bin/k9s --headless\"'" C-m

# Right pane: ssh into staging, set KUBECONFIG, run k9s
tmux send-keys -t "${SESSION}:󱃾.1" "ssh cluster.staging -t 'zsh -ilc \"export KUBECONFIG=/etc/rancher/k3s/k3s.yaml && ~/projects/kickstart.linux/bin/k9s --headless\"'" C-m

tmux new-window -t "${SESSION_NAME}:" -n ""
