

-- Create CMK in Azure Key Vault. Make sure you have access in AKV to create this step
CREATE COLUMN MASTER KEY [CMK_Auto4]
WITH
( KEY_STORE_PROVIDER_NAME = N'AZURE_KEY_VAULT',
KEY_PATH = N'https://srgoaekv.vault.azure.net:443/keys/CMKAuto4/6df37e31807987e6861bc1619d3521aa')
GO

-- Sample script to show how to create CEK. I removed few parts of the encrypted value for brevityg. Please use UI in SSMS to generate this step,
CREATE COLUMN ENCRYPTION KEY [CEK_Auto3]
WITH VALUES
(COLUMN_MASTER_KEY = [CMK_Auto4],
ALGORITHM = 'RSA_OAEP',
ENCRYPTED_VALUE = 0x01A6000001680074007400700073003A002F002F007300720067006F006100650
)
GO

-- Create Always encrypted table
CREATE TABLE [dbo].[tblClaims](
[Claimid] [int] NULL,
[Claimsource] [nvarchar](13) NULL,
[Rawtext] [nvarchar](max) COLLATE Latin1_General_BIN2 ENCRYPTED WITH (COLUMN_ENCRYPTION_KEY = [CEK_Auto3], ENCRYPTION_TYPE = Deterministic, ALGORITHM = 'AEAD_AES_256_CBC_HMAC_SHA_256') NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO