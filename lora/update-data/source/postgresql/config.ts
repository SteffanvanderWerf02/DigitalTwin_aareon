const fs = require('fs');
const yaml = require('js-yaml');

// Read YAML from a file
const data = fs.readFileSync('config.yaml', 'utf8');

// Parse YAML into JavaScript object
const env = yaml.load(data);

/* Een configuratie-object voor het postgres-pakket. */
const config = {
	host: env[0].database.host,
	port: env[0].database.port,
	user: env[0].database.user,
	password: env[0].database.password,
	database: env[0].database.db_name,
	ssl:false, 
	};

export default config;
