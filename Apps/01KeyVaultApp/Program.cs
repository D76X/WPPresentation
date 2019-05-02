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
    // Refs
    // https://damienbod.com/2019/02/07/using-azure-key-vault-from-an-non-azure-app/
    // https://blog.bitscry.com/2019/02/13/using-azure-key-vault-in-a-console-application/
    // https://azurecto.com/azure-keyvault-authenticating-with-certificates-and-reading-secrets/
    // https://stackoverflow.com/questions/47875589/cant-access-azure-key-vault-from-desktop-console-app
    // https://docs.microsoft.com/en-us/azure/key-vault/tutorial-net-create-vault-azure-web-app
    // https://github.com/damienbod/AspNetCoreBackChannelLogout/blob/master/ConsoleStandaloneUsingAzureSecrets/Program.cs

    // https://docs.microsoft.com/en-us/azure/key-vault/tutorial-net-create-vault-azure-web-app

    //{
    //"DNSNameKeyVault": "<DNS NAME from Key Vault>",
    //"AADAppRegistrationAppId": "<Azure AD App Registration Application ID>",
    //"AADAppRegistrationAppSecret": "<Azure AD App Registration Application Secret>",
    //"SomeSecret": "DEV_VALUE"
    //}

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

//--------------------------------------------------------------------------------------
// Application Registration
// https://damienbod.com/2019/02/07/using-azure-key-vault-from-an-non-azure-app/
// https://stackoverflow.com/questions/47875589/cant-access-azure-key-vault-from-desktop-console-app
// 01KeyVaultApp
// Application(client) ID: 3da2ec55-4670-4e30-b7f2-6c4a29ec9a3f
// Directory(tenant) ID : 981b07d1-b261-4c3e-a400-b86f7809d9bc
// Object ID : 2458fef3-3247-4fb2-a3ab-e144b93d1818
// Supported account types : My organization only
// Redirect URIs :Add a Redirect URI
// Managed application in local directory :01KeyVaultApp
// --------------------------------------------------------------------------------------
// https://damienbod.com/2019/02/07/using-azure-key-vault-from-an-non-azure-app/
// Now a secret for the AAD Application registration needs to be created.
// Click the Certificates & secrets button, and then New client secret.
// Store the client secret!
// /nKN++8?2m2LUUTdWva5bwcZHR__slTr
// /nKN++8?2m2LUUTdWva5bwcZHR__slTr
// --------------------------------------------------------------------------------------
// Secrets vs Certificates for Client App Registration
// Credentials enable applications to identify themselves to the authentication service when receiving tokens at a web addressable location(using an HTTPS scheme).
// For a higher level of assurance, we recommend using a certificate(instead of a client secret) as a credential.
//--------------------------------------------------------------------------------------
// Configure the Azure Key Vault to allow the Azure AD Application
// In the Azure Key Vault, the Application registration needs to be given access rights.
// Open the Key Vault, and click the Access policies. Then click the Add new button.
// Select the AAD Application registration principle which was created before. 
// You can find this, by entering the name of the app 01KeyVaultApp. 
// --------------------------------------------------------------------------------------
// Now configure the application to use the Key Vault.
// --------------------------------------------------------------------------------------

// https://www.rahulpnath.com/blog/pfx-certificate-in-azure-key-vault/
//// Client
//byte[] encryptedData;
//// You can also use the PFX here as it contains the private key
//var publicCertificate = new X509Certificate2(@"C:\CertificateKey.cer"); 
//using (var cryptoProvider = publicCertificate.PublicKey.Key as RSACryptoServiceProvider)
//{
//var byteData = Encoding.Unicode.GetBytes(textToEncrypt);
//encryptedData = cryptoProvider.Encrypt(byteData, true);
//}

////Server
//var privateCertificate = new X509Certificate2(@"C:\CertificateKey.pfx", "test");
//using (var cryptoProvider = privateCertificate.PrivateKey as RSACryptoServiceProvider)
//{
//var decryptedData = cryptoProvider.Decrypt(encryptedData, true);
//var decryptedText = Encoding.Unicode.GetString(decryptedData);
//}
//-----------------
//var keyIdentifier = "https://rahulkeyvault.vault.azure.net:443/keys/KeyFromCert/";

//// Client Remains the same or use the Key Vault Client
//var encryptedResult = await keyClient.EncryptAsync(keyIdentifier, "RSA-OAEP", byteData);

//// Server
//var decryptedData = await keyClient.DecryptAsync(keyIdentifier, "RSA-OAEP", certED);
//var decryptedText = Encoding.Unicode.GetString(decryptedData.Result);
//-------------
//var secretRetrieved = await keyClient.GetSecretAsync(secretIdentifier);
//var pfxBytes = Convert.FromBase64String(secretRetrieved.Value);
//File.WriteAllBytes(@"C:\cert\ADTestVaultApplicationNew.pfx", pfxBytes);

//// or recreate the certificate directly
//var certificate = new X509Certificate2(pfxBytes);
