#!/bin/bash

function save_cd() {
    cd "$1" || {
        echo "Error: failed to cd into '$1'."
        exit 1;
    }
}
