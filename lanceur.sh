#!/usr/bin/bash

perl outputs-alignment.pl ref/363052.txt sys1/363052.ann sys2/363052.ann sys3/363052.ann | perl rover-production.pl | perl brat-conversion.pl >ref/363052.ann
