<?php

// autoload_static.php @generated by Composer

namespace Composer\Autoload;

class ComposerStaticInit0c7fd6cccb99cd15487ce541c4ded902
{
    public static $prefixLengthsPsr4 = array (
        'S' => 
        array (
            'Symfony\\Component\\EventDispatcher\\' => 34,
        ),
        'I' => 
        array (
            'InfluxDB\\' => 9,
        ),
    );

    public static $prefixDirsPsr4 = array (
        'Symfony\\Component\\EventDispatcher\\' => 
        array (
            0 => __DIR__ . '/..' . '/symfony/event-dispatcher',
        ),
        'InfluxDB\\' => 
        array (
            0 => __DIR__ . '/..' . '/influxdb/influxdb-php/src/InfluxDB',
        ),
    );

    public static $prefixesPsr0 = array (
        'G' => 
        array (
            'Guzzle\\Tests' => 
            array (
                0 => __DIR__ . '/..' . '/guzzlehttp/guzzle/tests',
            ),
            'Guzzle' => 
            array (
                0 => __DIR__ . '/..' . '/guzzlehttp/guzzle/src',
            ),
        ),
    );

    public static function getInitializer(ClassLoader $loader)
    {
        return \Closure::bind(function () use ($loader) {
            $loader->prefixLengthsPsr4 = ComposerStaticInit0c7fd6cccb99cd15487ce541c4ded902::$prefixLengthsPsr4;
            $loader->prefixDirsPsr4 = ComposerStaticInit0c7fd6cccb99cd15487ce541c4ded902::$prefixDirsPsr4;
            $loader->prefixesPsr0 = ComposerStaticInit0c7fd6cccb99cd15487ce541c4ded902::$prefixesPsr0;

        }, null, ClassLoader::class);
    }
}
