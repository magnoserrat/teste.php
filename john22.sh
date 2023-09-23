#!/usr/bin/expect -f

# Defina as informações de login
set usuario "magno.serra"
set senha "300188ED"

# Lista de endereços IP dos equipamentos
set equipamentos {
    "172.16.6.238"
    "172.16.6.22"
}

# Comandos a serem executados
set comandos {
    "show system"
    "show uptime"
    "exit"
}

# Loop pelos equipamentos
foreach ip $equipamentos {
    # Use um bloco "catch" para capturar erros
    catch {
        spawn ssh $usuario@$ip
        expect {
            "Are you sure you want to continue connecting" {
                send "yes\r"
                exp_continue
            }
            "Password:" {
                send "$senha\r"
            }
        }

        expect ">"  ;# Aguarde o prompt do equipamento

        foreach comando $comandos {
            send "$comando\r"
            expect ">"  ;# Aguarde o prompt do equipamento após a execução do comando
        }

        send "exit\r" ;# Saia do equipamento SSH
        expect eof
        puts "Comandos executados em $ip"
    } result
    # Verifique se ocorreu um erro
    if {[lindex $result 0] == 1} {
        puts "Erro ao tentar conectar a $ip"
    }
}
