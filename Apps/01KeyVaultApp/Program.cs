using System;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Azure.KeyVault;
//using AzureResourceReport.Models;
//using Microsoft.Azure.Management.ResourceManager.Fluent;
//using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;

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
            Console.WriteLine("Hello World!");
            Console.ReadKey();

            
        }
    }
}
