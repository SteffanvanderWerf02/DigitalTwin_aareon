
using Microsoft.AspNetCore.Identity;

using System.Diagnostics;
using Npgsql;
using MySql.Data.MySqlClient;
using NpgsqlTypes;
using NuGet.Protocol.Plugins;
using System.Diagnostics.Metrics;
using System.Collections;

namespace dt_aareon_emmen.Models
{
    public class Database
    {
        public string connectionString { get; set; }
        private NpgsqlConnection dbConn;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public Database(string userId, string host, string password, string db, string port)
        {
            this.connectionString = $"UserId={userId};Host={host};Port={port};Password={password};Database={db}";
            this.dbConn = new NpgsqlConnection(this.connectionString); // install mysql package : dotnet add package MySql.Data --version 8.0.29
                                                                       // install postgresql package : dotnet add package Npgsql --version 5.0.8
            try
            {
                this.dbConn.Open();
                this.dbConn.Close();
            }
            catch (Exception ex)
            {
                Debug.WriteLine($"fail {ex}");
            }
        }

        /* dbClose()
         * 
         * Close the database connection
         * 
         */
        public Boolean DbClose()
        {
            try
            {
                this.dbConn.Close();
            }
            catch
            {
                return false;
            }
            return true;
        }

        /* dbOpen()
         * 
         * Open the database connection
         * 
         */
        public Boolean DbOpen()
        {
            try
            {
                this.dbConn.Open();
            }
            catch
            {
                return false;
            }
            return true;
        }

        /** selectQuery()
         * 
         * Execute a select query and return the records (NO PREPARED STATEMENTS)
         *
         * Example query:
            this.ViewBag.data = db.selectQuery(@"SELECT id, name FROM role", 
                                      new List<string> { "id", "name" });
         *
         * Request in view like this:
         --
        <ul>
           @foreach (var data in ViewBag.data)
            {
                @data["id"];
                @data["name"]
            }
        </ul>
         --
         */
        public List<Dictionary<string, string>> SelectQuery(string query, List<string> fields)
        {
            List<Dictionary<string, string>> records = new List<Dictionary<string, string>>();
            try
            {
                this.DbOpen();
                // instantiate the command and add the query to the command class
                NpgsqlCommand command = this.dbConn.CreateCommand();
                command.CommandText = query;

                // execute the reader (retrieve results)
                NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Dictionary<string, string> tempList = new Dictionary<string, string>();
                    foreach (string element in fields)
                    {
                        tempList.Add(element, reader[element].ToString());
                    }
                    records.Add(tempList);
                }

                this.DbClose();

                return records;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        /** selectQueryPs()
         * 
         * Execute a select query and return the records (WITH PREPARED STATEMENTS)
         * 
         * Example query:
             this.ViewBag.roleData = db.selectQueryPs("SELECT id, name FROM role WHERE id = @id", new List<string> { "id", "name" }, new Dictionary<string, string>()
                {
                    ["id"] = "50",
                })
         *
         * Request in view like this:
         --
            @foreach (var data in ViewBag.data)
            {
                @data["id"];
                @data["name"]
            }
         --
         or when requesting data for a single record
         --
           @ViewBag.data[0]["id"]
           @ViewBag.data[0]["name"] 
         --
         */
        public List<Dictionary<string, string>> SelectQueryPs(string query, List<string> fields, Dictionary<string, string> parameters)
        {
            List<Dictionary<string, string>> records = new List<Dictionary<string, string>>();
            try
            {
                this.DbOpen();
                // instantiate the command and add the query to the command class
                NpgsqlCommand command = this.dbConn.CreateCommand();
                command.CommandText = query;
                Console.WriteLine("Used query : " + command.CommandText);
                // temporary save all keys from the parameters parameter
                List<string> keys = new List<string>(parameters.Keys);

                foreach (string key in keys)
                {
                    command.Parameters.AddWithValue("@" + key, parameters[key]);
                }

                // execute the reader (retrieve results)
                Npgsql.NpgsqlDataReader reader = command.ExecuteReader();
                while (reader.Read())
                {
                    Dictionary<string, string> tempList = new Dictionary<string, string>();
                    foreach (string element in fields)
                    {
                        if (reader[element] != null)
                        {
                            tempList.Add(element, reader[element].ToString());
                        }
                    }
                    records.Add(tempList);
                }
                this.DbClose();

                return records;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }

        /** executeQuery()
         * 
         * Execute a insert, update or delete query (with prepared statements)
         * the order does matter!
         * 
         * Example query : 
         * 
         * 
            db.executeQuery("INSERT INTO role(id, name) VALUES (@id, @name)", new Dictionary<string, string>()
            {
                ["id"] = "50",
                ["name"] = "testRole"
            });
         * 
         */
        public Boolean ExecuteQuery(string query, Dictionary<string, string> parameters)
        {
            this.DbOpen();
            // instantiate the command object and add a query
            NpgsqlCommand command = this.dbConn.CreateCommand();
            command.CommandText = query;

            // temporary save all keys from the parameters parameter
            List<string> keys = new List<string>(parameters.Keys);

            // add all parameters (note that column name must match, and must be at the same spot as the column name in the query)
            foreach (string key in keys)
            {
                command.Parameters.AddWithValue($"@{key}", parameters[key]);
            }

            // prepare the query
            command.Prepare();

            // execute query
            if (command.ExecuteNonQuery() > 0)
            {
                this.DbClose();
                return true;
            }
            this.DbClose();

            return false;
        }

        public ArrayList ExecuteQueryWithResult(string query, Dictionary<string, string> parameters)
        {
            this.DbOpen();
            // Instantiate the command object and add a query
            NpgsqlCommand command = this.dbConn.CreateCommand();
            command.CommandText = query;

            // Temporary save all keys from the parameters parameter
            List<string> keys = new List<string>(parameters.Keys);

            // Add all parameters (note that column name must match and must be at the same spot as the column name in the query)
            foreach (string key in keys)
            {
                command.Parameters.AddWithValue($"@{key}", parameters[key]);
            }

            // Prepare the query
            command.Prepare();

            NpgsqlDataReader reader;
            ArrayList records = new ArrayList();

            // Execute query
            using (reader = command.ExecuteReader())
            {
                while (reader.Read())
                {
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        object value = reader.GetValue(i);
                        string stringValue = value?.ToString(); // Convert to string

                        records.Add(stringValue);
                    }
                }
            }

            this.DbClose();

            return records;
        }
    }
}