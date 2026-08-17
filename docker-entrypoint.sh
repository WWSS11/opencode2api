#!/bin/sh
set -eu

app_dir=${APP_DIR:-/app}
config_path=${CONFIG_PATH:-$app_dir/config/config.json}
listen_address=${LISTEN_ADDRESS:-0.0.0.0:8080}
webui_listen_address=${WEBUI_LISTEN_ADDRESS:-0.0.0.0:8081}
example_config=/usr/share/opencode2api/config.example.json

mkdir -p "$(dirname "$config_path")"

if [ ! -f "$config_path" ]; then
    cp "$example_config" "$config_path"
    printf '%s\n' "config.json not found; using a persistent generated copy. Set real API keys or enable anonymous mode, and change the WebUI password before use."
fi

exec /usr/local/bin/opencode2api -config "$config_path" -listen "$listen_address" -web-listen "$webui_listen_address" "$@"
