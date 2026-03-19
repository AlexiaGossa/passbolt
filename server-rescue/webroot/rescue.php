<?php

require dirname(__DIR__) . '/config/paths.php';

function env(string $key, string|float|int|bool|null $default = null): string|float|int|bool|null
{
    return $default;
}

function PassboltConfig ( )
{
    return include dirname(__DIR__) . '/config/passbolt.php';
}

$oConfig = PassboltConfig ( );

if (!isset($_GET['email'])) {
    showPage ( );
}


try {
    $pdo = new PDO ( 
        'mysql:host='.$oConfig['Datasources']['default']['host'].';port='.$oConfig['Datasources']['default']['port'].';dbname='.$oConfig['Datasources']['default']['database'].';charset=utf8',
        $oConfig['Datasources']['default']['username'],
        $oConfig['Datasources']['default']['password'] );
} catch (PDOException $e) {
    die();
}


$sQuery = "select * from authentication_tokens where user_id = (select id from users where username = :email ) and type = 'recover' order by created DESC LIMIT 1";
$stmt = $pdo->prepare($sQuery);
$stmt->bindParam ( ':email', $_GET['email'] );
$success = $stmt->execute();
$result  = ($success)?($stmt->fetchAll(PDO::FETCH_ASSOC)):(null);
if (count($result)==1)
{
    echo $oConfig['App']['fullBaseUrl'].'/setup/recover/'.$result[0]['user_id'].'/'.$result[0]['token'];
}

function showPage ( )
{
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <title>Récupération</title>
</head>
<body>
 <h1>Récupération de compte Passbolt sans email</h1>
    <form id="rescueForm">
        <label for="email">Adresse email :</label>
        <input type="email" id="email" name="email" required>
        <button type="submit">Récupérer</button>
    </form>

    <script>
        document.getElementById('rescueForm').addEventListener('submit', async function (e) {
            e.preventDefault();

            const email = document.getElementById('email').value;

            try {
                const response = await fetch('rescue.php?email=' + encodeURIComponent(email));
                const url = await response.text();

                if (url) {
                    window.location.href = url;
                } else {
                    alert('Aucune URL retournée.');
                }
            } catch (error) {
                alert('Erreur lors de la récupération.');
                console.error(error);
            }
        });
    </script>
</body>
</html>
<?php 
    die ();
}
