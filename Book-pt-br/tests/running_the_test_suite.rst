.. _runing_the_test_suite:

Running the test suite
======================

Now that we have an basic understanding of what kind of testing we're doing, let's run the test suite. Before we can run
the tests, make sure you have successfully built php from source (see :ref:`building_php`) and you have an executable
at ``sapi/cli/php``.

There are two ways to run the test suite.

Running tests directly with ``run-tests.php``
---------------------------------------------

You can run the test suite directly with run-tests.php. At minimum you'll need to specify the php executable that you
wish to test against which you can do with the ``-p`` flag. Note that in order to run all tests correctly this should be
an absolute path to the PHP executable.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -p `pwd`/sapi/cli/php

A shortcut flag you can use to tell run-tests to test against the PHP executable that is currently invoked is by using
the ``-P`` flag.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -P

If you don't want to have to set the ``-p`` or ``-P`` flag every time, you could specify the php executable with the
``TEST_PHP_EXECUTABLE`` environment variable which can be set with ``export`` on Linux machines.

.. code-block:: bash

    ~/php-src> export TEST_PHP_EXECUTABLE=sapi/cli/php
    ~/php-src> sapi/cli/php run-tests.php

On Windows you can set the environment variable using ``set``.

.. code-block:: bash

    C:\php-src> set TEST_PHP_EXECUTABLE=sapi/cli/php
    C:\php-src> sapi/cli/php run-tests.php

By default ``run-tests.php`` will start running all 15,000+ tests in the test suite which would take forever-ever. You
can specify a target folder of tests to run or even a single test. The following example will run all the tests
associated with `PHP 7's CSPRNG`_.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -P ext/standard/tests/random

You can also specify multiple target folders or files to run.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php -P Zend/ ext/reflection/ ext/standard/tests/array/

Hopefully all the tests will have passed. If not... oops.

.. _PHP 7's CSPRNG: http://php.net/csprng

Running tests via the ``Makefile`` (recommended)
------------------------------------------------

The recommended way of running the test suite is via the ``test`` target which is defined in the ``Makefile``. The
``test`` target does all the hard work of specifying the PHP executable for you (the one you compiled), setting up some
default INI settings and specifying the best run-tests flags for you. You needn't worry about setting environment
variables or setting additional flags so the command is very simple.

.. code-block:: bash

    ~/php-src> make test

As before, ``run-tests.php`` will start running the entire test suite. To specify a folder or single test to execute you
can pass ``make`` a ``TESTS`` variable. The following example will test that PHP can handle binary literals properly.

.. code-block:: bash

    ~/php-src> make test TESTS=Zend/tests/binary.phpt

You can specify multiple target folders or files to run by separating each path with a space in the ``TESTS`` variable.

.. code-block:: bash

    ~/php-src> make test TESTS="Zend/ ext/reflection/ ext/standard/tests/array/"

Executing tests in parallel
---------------------------

You can't.

More options
------------

For a full list of supported options that run-tests supports, just run it with ``--help``.

.. code-block:: bash

    ~/php-src> sapi/cli/php run-tests.php --help
