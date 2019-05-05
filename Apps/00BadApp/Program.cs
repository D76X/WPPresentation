using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _00BadApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine($"Start Application {System.Reflection.Assembly.GetExecutingAssembly().GetName().Name} and get key vault values");
            string connectionString = ConfigurationManager.AppSettings["connectionString"];
            Console.WriteLine($"{nameof(connectionString)}={connectionString}");
            Console.WriteLine();

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand("SELECT * FROM People", connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                Console.WriteLine(reader.GetValue(i));
                            }
                            Console.WriteLine();
                        }
                    }
                }
            }

            Console.WriteLine();
            Console.WriteLine("Press any key to exit.");
            Console.ReadKey();
        }
    }
}
