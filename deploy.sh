#!/bin/bash

DST=${1:-pair07}

scp sender* receiver* $DST:.
