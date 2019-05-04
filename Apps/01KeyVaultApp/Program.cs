using System;
using System.Configuration;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.Azure.KeyVault;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
//using AzureResourceReport.Models;
//using Microsoft.Azure.Management.ResourceManager.Fluent;
//using Microsoft.Azure.Management.ResourceManager.Fluent.Authentication;

namespace _01KeyVaultApp
{
    

    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Start Application and get key vault values");

            // https://stackoverflow.com/questions/1189364/reading-settings-from-app-config-or-web-config-in-net
            string config_aad_appId = ConfigurationManager.AppSettings["aad_appId"];
            string config_aad_clientsecret = ConfigurationManager.AppSettings["aad_clientsecret"];
            string config_kv_dnsname = ConfigurationManager.AppSettings["kv_dnsname"];
            string config_kv_key = ConfigurationManager.AppSettings["kv_key"];

            Console.WriteLine($"{config_aad_appId}");
            Console.WriteLine($"{config_kv_dnsname}");
            Console.WriteLine($"{config_kv_key}");

            // https://docs.microsoft.com/en-us/dotnet/api/overview/azure/key-vault?view=azure-dotnet
            //var keyClient = new KeyVaultClient(new KeyVaultClient.AuthenticationCallback(securityToken));
            //await GetSecretAsync("https://YOURVAULTNAME.vault.azure.net/", "YourSecretKey");

            Console.ReadKey();
        }

        // https://stackoverflow.com/questions/47875589/cant-access-azure-key-vault-from-desktop-console-app
        private static async Task<string> GetSecretAsync(string vaultUrl, string vaultKey)
        {
            var client = new KeyVaultClient(new KeyVaultClient.AuthenticationCallback(GetAccessTokenAsync), new HttpClient());
            var secret = await client.GetSecretAsync(vaultUrl, vaultKey);

            return secret.Value;
        }

        private static async Task<string> GetAccessTokenAsync(string authority, string resource, string scope)
        {
            //DEMO ONLY
            //Storing ApplicationId and Key in code is bad idea :)
            var appCredentials = new ClientCredential("YourApplicationId", "YourApplicationKey");
            var context = new AuthenticationContext(authority, TokenCache.DefaultShared);

            var result = await context.AcquireTokenAsync(resource, appCredentials);

            return result.AccessToken;
        }
    }
}


