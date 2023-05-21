using System;
using System.Data;
using System.Data.SqlClient;
using System.Threading;

namespace Deadlock
{
    internal static class Program
    {
        private const string ConnectionString = 
            "Data Source=GABI\\SQLEXPRESS;Initial Catalog=MAGAZIN_DE_JOCURI; Integrated Security=True";
        
        public static void Main()
        {
            Thread deadlock1 = new Thread(RunDeadlock1);
            Thread deadlock2 = new Thread(RunDeadlock2);

            Console.WriteLine("Starting deadlock.");
            
            deadlock1.Start();
            deadlock2.Start();
        }
        
        private static void RunDeadlock1()
        {
            RunProcedure("deadlock_tran1");
        }

        private static void RunDeadlock2()
        {
            RunProcedure("deadlock_tran2");
        }

        private static void RunProcedure(string procedure)
        {
            SqlConnection connection = new SqlConnection(ConnectionString);
            SqlCommand command = new SqlCommand(procedure, connection);
            command.CommandType = CommandType.StoredProcedure;
            connection.Open();
            
            Console.WriteLine("Started procedure: {0}", procedure);
            
            int rowsAffected = 0;
            try
            {
                rowsAffected = command.ExecuteNonQuery();
                Console.WriteLine("{0} executed successfully. {1} rows affected.", procedure, rowsAffected);
            }
            catch (Exception ex)
            {
                Console.WriteLine("{0} failed: {1}", procedure, ex.Message);
                int tries = 3;
                while (tries > 0)
                {
                    tries--;
                    Console.WriteLine("Rerunning {0}. Tries left: {1}", procedure, tries);
                    try
                    {
                        rowsAffected = command.ExecuteNonQuery();
                        tries = -1;
                        Console.WriteLine("{0} executed successfully. {1} rows affected.", procedure, rowsAffected);
                    }
                    catch (Exception ex1)
                    {
                        Console.WriteLine("{0} failed: {1}", procedure, ex1.Message);
                    }
                }
            }
            finally
            {
                connection.Close();
            }
        }

    }
}
