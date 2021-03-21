<?php

declare(strict_types=1);

require_once __DIR__ . '/../src/db/Connection.php';

const MIGRATE_FILE = __DIR__ . '/migrate.sql';

$connection = \app\DB\Connection::getInstance();

$sql = file_get_contents(MIGRATE_FILE);

if ($sql === false) {
    throw new RuntimeException(MIGRATE_FILE . ' file should exists');
}

$connection->exec($sql);
