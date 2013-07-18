#!/bin/bash

DST=${1:-pair07}

scp receiver* $DST:.
