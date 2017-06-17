#!/usr/bin/env php
<?php

$options = [
    '--with-gmp',
    '--enable-opcache',
    '--enable-intl --with-icu-dir=' . trim(`brew --prefix icu4c`),
    '--with-openssl=' . trim(`brew --prefix openssl`),
];

$keyOptions = [];
foreach ($options as $option) {
    preg_match('/^([a-z\-]+).*$/', $option, $matches);
    $key = $matches[1];
    $keyOptions[$key] = $option;
}

$file = $argv[1];
foreach (file($file) as $line) {
    $line = trim($line);

    // replace
    foreach ($keyOptions as $key => $option) {
        if (strpos($line, $key) === 0) {
            $line = $option;
            unset($keyOptions[$key]);
            break;
        }
    }

    echo $line, PHP_EOL;
}

// add
foreach ($keyOptions as $option) {
    echo $option, PHP_EOL;
}
