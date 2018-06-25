#!/bin/bash

ps -u yuanlai | grep -i globus | awk '{print $1}' | xargs kill
