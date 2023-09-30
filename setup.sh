#!/bin/bash
set -e

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none --profile minimal
echo "$HOME/.cargo/bin" >> $GITHUB_PATH

args=()

# shellcheck disable=SC2206
[[ -n "${INPUT_COMPONENTS}" ]] && args+=(-c "${INPUT_COMPONENTS// /}")

# shellcheck disable=SC2206
[[ -n "${INPUT_TARGETS}" ]] && args+=(-t "${INPUT_TARGETS// /}")

rustup toolchain install "${INPUT_RUST_VERSION}" --profile "${INPUT_PROFILE}" "${args[@]}"
rustup default "${INPUT_RUST_VERSION}"

# shellcheck disable=SC2129
echo "rustup_version=$(rustup --version)" >> $GITHUB_OUTPUT
echo "cargo_version=$(cargo --version)" >> $GITHUB_OUTPUT
echo "rustc_version=$(rustc --version)" >> $GITHUB_OUTPUT

echo "::add-matcher::${GITHUB_ACTION_PATH%/}/matcher.json"