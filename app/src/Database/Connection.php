<?php

declare(strict_types=1);

namespace app\Database;

use PDO;
use RuntimeException;

class Connection
{
    public const ENV_DB_HOST     = 'DB_HOST';
    public const ENV_DB_USER     = 'DB_USER';
    public const ENV_DB_NAME     = 'DB_NAME';
    public const ENV_DB_PASSWORD = 'DB_PASSWORD';

    private static ?PDO $instance = null;

    private function __construct()
    {
    }

    public static function getInstance(): PDO
    {
        if (!self::$instance) {
            self::$instance = self::init();
        }

        return self::$instance;
    }

    private static function init(): PDO
    {
        $credentials = self::getDBCredentials();

        return new PDO(
            sprintf('pgsql:host=%s;dbname=%s', $credentials[self::ENV_DB_HOST], $credentials[self::ENV_DB_NAME]),
            $credentials[self::ENV_DB_USER],
            $credentials[self::ENV_DB_PASSWORD]
        );
    }

    public static function getDBCredentials(): array
    {
        $credentials = [
            self::ENV_DB_HOST => getenv(self::ENV_DB_HOST) ?: null,
            self::ENV_DB_USER => getenv(self::ENV_DB_USER) ?: null,
            self::ENV_DB_NAME => getenv(self::ENV_DB_NAME) ?: null,
            self::ENV_DB_PASSWORD => getenv(self::ENV_DB_PASSWORD),
        ];

        $emptyValues = array_filter(
            $credentials,
            static function ($value) {
                return $value === null;
            }
        );

        if ($emptyValues) {
            throw new RuntimeException(
                sprintf(
                    'Misconfiguration. Please add following env variables: %s',
                    implode(',', array_keys($emptyValues))
                )
            );
        }

        return $credentials;
    }
}
