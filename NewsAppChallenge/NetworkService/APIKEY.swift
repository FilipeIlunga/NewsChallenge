//
//  APIKEY.swift
//  NewsAppChallenge
//
//  Created by Filipe Ilunga on 15/05/24.
//

import Foundation

struct APIKey {
    #warning("Vulnerabilidade")
    // Numa aplicação real não deixaria a chave da API exposta desta maneira,
    // Mas para que vocês possam testar a aplicação sem problemas, decidi deixar desta forma.
    // Numa aplicação real eu faria a chave ser armazenada de forma segura em variáveis de ambiente,
    // usando um arquivo de configuração ignorado pelo git (por exemplo, .plist),
    // ou em um serviço de gerenciamento de senhas (como o Keychain da Apple).
    static let value = "3b072af476bc46a7b397063a60ea8d43"
}

