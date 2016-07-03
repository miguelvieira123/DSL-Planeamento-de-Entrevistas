<?php
      $vars = $_POST;
      $old_error_handler = set_error_handler("myErrorHandler");

      // tornar a string segura
      if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
        $texto = mres( $vars["phrase"] );
        $vars["machine"] = "windows";
      } else {
        $texto = escapeshellarg($vars["phrase"]);
        $vars["machine"] = "linux";
      }



      //executar gramatica
      exec("perl ./gramaticas/gramatica_teste.pl ".$texto, $out, $code);

      // recolher prints
      $i=0;
      $xml_str = "";
      foreach($out as $line) {
        if (strpos("_".$line, 'Marpa::R2 exception') == false) {
          if (strpos("_".$line, 'FILENAME:') == false) {
            $vars["msg"][$i] = $line;
            $xml_str .= $line;
            $i++;
          }else {
            $match = preg_split("/:/", $line);
            $vars["filename"] = $match[1];
          }
        }

      }

      //validar XML com schema
      if ($code == 0) {
        # code...
        $xml= new DOMDocument();
        $xml->loadXML($xml_str); // Or load if filename required
        if (!$xml->schemaValidate("projeto.xsd")){ // Or schemaValidateSource if string used.
          $vars["valid_xml"]="no";
        }else {
          $vars["valid_xml"]="yes";
        }
      }

      //enviar mensagens para o cliente
      $vars["succ"] = $code;
      echo json_encode($vars);


      // funcoes auxiliares --------------------------------------------
      function mres($value){
          $search = array("\\",  "\x00", "\n",  "\r",  "'",  '"', "\x1a","<", ">" );
          $replace = array("\\\\","\\0","\\n", "\\r", "\'", '\"', "\\Z", "^<","^>");
          return str_replace($search, $replace, $value);
      }

      function myErrorHandler($errno, $errstr, $errfile, $errline){
        if (!(error_reporting() & $errno)) {
          // This error code is not included in error_reporting
          return;
        }

        switch ($errno) {
          case LIBXML_ERR_FATAL:
          $vars["msg"] = "xml schema fatal error\n";
          $vars["succ"] = 53;
          //echo json_encode($vars);
          break;

          case LIBXML_ERR_WARNING:
          $vars["msg"] = "WARNING: [$errno] $errstr";
          $vars["succ"] = 54;
          //echo json_encode($vars);
          break;

          case LIBXML_ERR_ERROR:
          $vars["msg"]= "ERROR [$errno] $errstr";
          $vars["succ"] = 55;
          //echo json_encode($vars);
          break;

          default:
          //echo "Unknown error type: [$errno] $errstr<br />\n";
          break;
        }

        /* Don't execute PHP internal error handler */
        return true;
      }






 ?>
