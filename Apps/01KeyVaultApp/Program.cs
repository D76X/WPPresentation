using System;
using AzureResourceReport.Models;
using Microsoft.Azure.KeyVault;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;
using Microsoft.IdentityModel.Clients.ActiveDirectory;

namespace _01KeyVaultApp
{
    // Refs
    // https://damienbod.com/2019/02/07/using-azure-key-vault-from-an-non-azure-app/
    // https://blog.bitscry.com/2019/02/13/using-azure-key-vault-in-a-console-application/
    // https://azurecto.com/azure-keyvault-authenticating-with-certificates-and-reading-secrets/
    // https://stackoverflow.com/questions/47875589/cant-access-azure-key-vault-from-desktop-console-app
    // https://docs.microsoft.com/en-us/azure/key-vault/tutorial-net-create-vault-azure-web-app

    class Program
    {
        static void Main(string[] args)
        {
            // The code provided will print ‘Hello World’ to the console.
            // Press Ctrl+F5 (or go to Debug > Start Without Debugging) to run your app.
            Console.WriteLine("Hello World!");
            Console.ReadKey();

            // Go to http://aka.ms/dotnet-get-started-console to continue learning how to build a console app! 
        }
    }
}
