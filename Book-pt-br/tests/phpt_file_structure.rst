.. _phpt_file_structure:

A estrutura de um arquivo ``.phpt``
===================================

Agora que sabemos como rodar os testes com o run-tests, vamos nos aprofundar em um arquivo phpt com mais detalhes. Um arquivo phpt é apenas um
arquivo PHP normal que contém uma quantidade de diferentes seções que o run-tests suporta.

Um exemplo básico de teste
--------------------------

Aqui tem um exemplo básico de um teste do fonte do PHP que testa a construção ``echo``.

.. literalinclude:: echo_basic.phpt
   :language: php

Você sabia que o `echo pode receber uma lista de argumentos`_? Bem, agora você sabe.

Existem `muitas outras seções`_ que ficam disponíveis para nós em um arquivo phpt, mas essas três são as minimamente necessárias.
A seção ``--EXPECT--`` tem algumas poucas variações mas nós vamos entrar na descrição das seções daqui a pouco.

Perceba que dessas três seções, nós temos tudo que precisamos para rodar um teste caixa-preta. Temos um nome para o teste, um
trecho de código e o resultado esperado. Novamente, um teste caixa-preta não se importa em *como* o código roda, ele se preocupa apenas
com o resultado final.

.. _echo pode receber uma lista de argumentos: http://php.net/manual/en/function.echo.php
.. _muitas outras seções: http://qa.php.net/phpt_details.php

Algumas seções importantes
--------------------------

Agora que vimos as três seções obrigatórias em todo arquivo ``.phpt`` vamos dar uma olhada em algumas outras seções comuns
que sem dúvida vamos encontrar.

``--TEST--`` : O nome do teste
    A `seção --TEST--`_ apenas descreve o teste (para humanos) em uma linha. Ela será mostrada no console quando
    o teste for executado, por isso é bom que seja descritivo mas não verboso demais. Se seu teste precisar de uma descrição mais longa, adicione
    uma `seção --DESCRIPTION--`_.
    
    .. code-block:: php
    
        --TEST--
        json_decode() with large integers

    .. note:: A seção ``--TEST--`` precisa ser a primeira linha de um arquivo phpt. Caso contrário o run-tests não
              o considerará como um arquivo de teste válido e marcará o teste como "quebrado".

``--FILE--`` : O código PHP a ser executado
    A `seção --FILE--`_ é o código PHP que vamos quere testar. Em nosso exemplo acima queremos garantir que a construção
    ``echo`` pode receber uma lista de argumentos e concatená-los na saída padrão (standard out).

    .. code-block:: php
    
        --FILE--
        <?php
        $json = '{"largenum":123456789012345678901234567890}';
        $x = json_decode($json);
        var_dump($x->largenum);
        $x = json_decode($json, false, 512, JSON_BIGINT_AS_STRING);
        var_dump($x->largenum);
        echo "Done\n";
        ?>

    .. note:: Embora seja considerada uma boa prática não usar a tag de fechamento PHP (``?>``) no *userland*, isso não acontece
              com um arquivo phpt. Se você não usar a tag de fechamento PHP, o run-tests não terá problemas
              para executar seu teste, mas ele não poderá mais ser executado como um arquivo PHP normal. Ele também fará
              com que sua IDE fique maluca. Por isso sempre lembre de incluir a tag de fechamento PHP em toda seção ``--FILE--``.

``--EXPECT--`` : A saída esperada
    A `seção --EXPECT--`_ contém exatamente o que esperamos ver na saída padrão. Se você estiver esperando
    asserções sofisticadas como a que você tem no `PHPUnit`_, você não receberá nenhuma delas aqui. Lembre-se, estes são *`testes funcionais`_* que
    apenas examinam a saída após o fornecimento de entradas.
    
    .. code-block:: php
    
        --EXPECT--
        float(1.2345678901235E+29)
        string(30) "123456789012345678901234567890"
        Done

    .. note:: As novas linhas finais são removidas pelo run-tests tanto da saída esperada quando da real, assim você não tem que
              se preocupar em adicionar ou remover novas linhas finais no fim da seção ``--EXPECT--``.

``--EXPECTF--`` : A saída esperada com substituição
    Como os testes precisam rodar em uma variedade de ambientes, muitas vezes não saberemos qual será a saída real
    de um script. Ou talvez a funcionalidade que estamos testando seja não-determinística. Para esse caso de uso nós temos
    a `seção --EXPECTF--`_ que nos permite substituir seções da saída com caracteres de substituição bem
    parecidos com a `função sprintf()`_ em PHP.
    
    .. code-block:: php
    
        --EXPECTF--
        string(%d) "%s"
        Done
    
    Isto é particularmente útil quando estamos criando testes com casos de erro que imprimem o caminho absoluto do arquivo PHP; algo
    que deve variar de ambiente para ambiente.

    Abaixo está um exemplo abreviado de caso de erro retirado de `um teste real`_ das `funções de password hashing`_ que
    usa a seção ``--EXPECTF--``.
    
    .. code-block:: php
    
        --TEST--
        Test error operation of password_hash() with bcrypt hashing
        --FILE--
        <?php
        var_dump(password_hash("foo", PASSWORD_BCRYPT, array("cost" => 3)));
        ?>
        --EXPECTF--
        Warning: password_hash(): Invalid bcrypt cost parameter specified: 3 in %s on line %d
        NULL

``--SKIPIF--`` : Condições para que um teste seja ignorado
    Como o PHP pode ser configurado com uma miríade de opções, a compilação do PHP que você está rodando pode não ter sido compilada com as
    dependências necessárias para executar um teste. O caso onde isso é mais comum é com teste de extensões.
    
    Se um teste precisar de uma extensão instalada para que consiga rodar ele precisará ter uma `seção --SKIPIF--`_ que verifica se
    a extensão está realmente instalada.
    
    .. code-block:: php
    
        --SKIPIF--
        <?php if (!extension_loaded('json')) die('skip ext/json must be installed'); ?>
    
    Qualquer teste que atenda à condição de ``--SKIPIF--`` será marcado como "skipped" pelo run-tests que continuará rodando o
    próximo teste na fila. Todo texto depois da palavra "skip" será retornado na saída quando você rodar o teste a partir
    do run-tests mostrando o motivo pelo qual o teste foi ignorado.
    
    Muitos dos testes interromperão a execução do script com `die()`_ ou `exit()`_ se a condição em ``--SKIPIF-- for atendida
    como no exemplo acima. É importante entender que só porque você colocou ``die()`` em uma seção ``--SKIPIF--``,
    isso não significa que o run-tests irá ignorar seu teste. O run-tests apenas examina a saída de ``--SKIPIF--`` e procura
    pela palavra "skip" como os primeiros quatro caracteres. Se a primeira palavra não for "skip", o teste não será ignorado.
    
    Na verdade, você não tem que interromper a execução em nenhum momento desde que "skip" seja a primeira palavra na saída.
    
    O seguinte exemplo irá ignorar um teste. Perceba que nós não interrompemos a execução do script.
    
    .. code-block:: php
    
        --SKIPIF--
        <?php if (!extension_loaded('json')) echo 'skip'; ?>
    
    Em contraste, examine o exemplo a seguir. Perceba como ele interrompe a execução do script mas como a palavra "skip" não
    é a primeira palavra na saída, o run-tests continuará a rodar o teste alegremente sem ignorá-lo.
    
    .. code-block:: php
    
        --SKIPIF--
        <?php if (!extension_loaded('json')) exit; ?>
    
    .. note:: Embora não seja obrigatório interromper a execução do script na seção ``--SKIPIF--``, é altamente
              recomendado fazê-lo assim você pode continuar a rodar o arquivo phpt como um arquivo php normal e ver uma mensagem agradável como "skip
              ext/json must be installed" em vez de receber um monte de erros aleatórios.

``--INI--``
    Às vezes os testes necessitam que configurações INI bem específicas estejam definidas. Nesse caso você pode definir qualquer configuração INI com a
    `seção --INI--`_. Cada configuração INI é colocada em uma nova linha dentro da seção.
    
    .. code-block:: php
    
        --INI--
        date.timezone=America/Chicago
    
    O run-tests faz para você toda a mágica que envolve definir as configurações INI.

.. _seção --TEST--: http://qa.php.net/phpt_details.php#test_section
.. _seção --DESCRIPTION--: http://qa.php.net/phpt_details.php#description_section
.. _seção --FILE--: http://qa.php.net/phpt_details.php#file_section
.. _seção --EXPECT--: http://qa.php.net/phpt_details.php#expect_section
.. _PHPUnit: https://phpunit.de/
.. _testes funcionais: https://en.wikipedia.org/wiki/Functional_testing
.. _seção --EXPECTF--: http://qa.php.net/phpt_details.php#expectf_section
.. _função sprintf(): http://php.net/sprintf
.. _um teste real: https://github.com/php/php-src/blob/master/ext/standard/tests/password/password_bcrypt_errors.phpt
.. _funções de password hashing: http://php.net/password
.. _seção --SKIPIF--: http://qa.php.net/phpt_details.php#skipif_section
.. _die(): http://php.net/die
.. _exit(): http://php.net/exit
.. _seção --INI--: http://qa.php.net/phpt_details.php#ini_section

Escrita de um teste simples
---------------------------

Vamos escrever nosso primeiro teste apenas para ficarmos familiarizados com o processo.

Normalmente os testes são armazenados em um diretório ``tests/`` que fica junto ao código que queremos testar. Por exemplo, a `extensão
PDO`_ é encontrada em ``ext/pdo`` no código fonte do PHP. Se você abrir esse diretório, verá um `diretório tests/`_
com vários arquivos ``.phpt`` dentro dele. Todas as outras extensões são definidas da mesma forma. Também existem testes para o Zend
engine que estão localizados em `Zend/tests/`_.

Para este exemplo, vamos criar temporariamente um arquivo de teste no diretório raiz do ``php-src``. Crie e abra um novo arquivo
com seu editor favorito.

.. code-block:: bash

    $ vi echo_basic.phpt

.. note:: Se você nunca tiver usado o vim, provavelmente ficará travado depois de rodar o comando acima. Apenas aperte
          ``<esc>`` alguma vezes e então digite ``:q!`` e isso deve te levar de volta para o seu terminal. Você pode
          usar seu editor favorito para esta parte em vez do vim. E então quanto tiver um tempo no futuro, `aprenda
          vim`_.

Agora copie e cole o teste de exemplo daqui de cima para o seu arquivo de teste novo. Aqui está novamente o arquivo de teste para te economizar
algum tempo de rolagem.

.. literalinclude:: echo_basic.phpt
   :language: php

Depois que você salvar o arquivo como ``echo_basic.phpt`` na raiz do código fonte PHP e sair de seu editor, execute o teste
de exemplo usando o make.

.. code-block:: bash

    $ make test TESTS=echo_basic.phpt

Se tudo tiver funcionado, você verá o seguinte resumo do teste passando.

.. code-block:: bash

    =====================================================================
    Running selected tests.
    PASS echo - Teste básico para a construção de linguagem echo [echo_basic.phpt]
    =====================================================================
    Number of tests :    1                 1
    Tests skipped   :    0 (  0.0%) --------
    Tests warned    :    0 (  0.0%) (  0.0%)
    Tests failed    :    0 (  0.0%) (  0.0%)
    Expected fail   :    0 (  0.0%) (  0.0%)
    Tests passed    :    1 (100.0%) (100.0%)
    ---------------------------------------------------------------------
    Time taken      :    0 seconds
    =====================================================================

Perceba como o texto da seção ``--TEST--`` do teste está sendo mostrada no console:

.. code-block:: bash

    PASS echo - Teste básico para a construção de linguagem echo [echo_basic.phpt]

Para ilustar a afirmação de que o teste caixa-preta apenas se importa com a saída, vamos alterar o código PHP na
seção ``--FILE--`` e manter todo o restante da mesma forma.

.. code-block:: php

    <?php
    const BANG = '!';
    class works {}
    echo sprintf('%s e recebe argumentos%s', works::class, BANG);
    ?>

Agora vamos executar o teste novamente.

.. code-block:: bash

    $ make test TESTS=echo_basic.phpt

O teste deve continuar passando pois a saída esperada continua sendo a mesma que antes. Vamos tentar outro exemplo.
Substitua o código PHP da seção ``--FILE--`` do teste pelo seguinte código e então execute o teste novamente.

.. code-block:: php

    <?php
    $url = 'https://gist.githubusercontent.com/SammyK/9c7bf6acdc5bcaa2cfbb404adc61abe6/';
    $url .= 'raw/04af30473fc78033f7d8941ecd567934b0f804c0/foo-phpt-output.txt';
    echo file_get_contents($url);
    ?>

Embora possa parecer obscuro, eu defini um `Gist com o resultado esperado`_ e nós estamos apenas jogando o body de uma
requisição HTTP para aquele Gist. A menos que tenhamos problema com conexão de rede ou se o gist for deletado, isso irá produzir a mesma
saída que os outros trechos de código e o teste continua passando. Ele irá falhar se você não tiver a extensão `ext/openssl`_
instalado uma vez que o Gist está atras.

Vamos tentar mais um exemplo. Substitua o código PHP na seção ``--FILE--`` pelo seguinte.

.. code-block:: php

    <?php
    ob_start();

    echo 'and ';
    sleep(1);
    echo 'takes ';
    sleep(1);
    echo 'args!';

    $foo = ob_get_contents();
    ob_clean();

    echo 'This works ';
    sleep(1);
    echo $foo;
    ?>

Louco, não? Ele vai levar alguns segundos apenas para retornar uma string única e você nunca faz isso na vida real, mas o
teste vai continuar passando. O run-tests não se importa se o seu código é lento [#]_, ineficiente ou apenas terrível, se
o resultado esperado bater com a saída real, sei teste será da cor verde.

.. _Extensão PDO: http://php.net/pdo
.. _diretório tests/: https://github.com/php/php-src/tree/master/ext/pdo/tests
.. _Zend/tests/: https://github.com/php/php-src/tree/master/Zend/tests
.. _aprenda vim: https://www.google.com/search?q=learn+vim
.. _Gist com o resultado esperado: https://gist.githubusercontent.com/SammyK/9c7bf6acdc5bcaa2cfbb404adc61abe6/raw/04af30473fc78033f7d8941ecd567934b0f804c0/foo-phpt-output.txt
.. _ext/openssl: http://php.net/openssl
.. [#] **Timeouts:** The default timeout for run-tests is 60 seconds (or 300 seconds when testing for memory leaks) but you can specify a different timeout using the ``--set-timeout`` flag.
