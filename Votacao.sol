// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Votacao {

    // 1. Variáveis de Estado

    address public administrador;

    struct Candidato {
        string nome;
        uint contagemVotos;
    }

    // Guarda os candidatos
    Candidato[] public candidatos;

    // Mapeamento para rastrear quais eleitores já votaram
    mapping(address => bool) public eleitoresQueVotaram;

    // Booleano para controlar se a votação está aberta ou fechada
    bool public votacaoAberta;

    // 2. Modificadores
    modifier apenasAdmin() {
        require(msg.sender == administrador, "Apenas o administrador pode fazer isso.");
        _;
    }

    // Modificador para garantir que a votação esteja aberta
    modifier apenasAberta() {
        require(votacaoAberta, "A votacao nao esta aberta.");
        _;
    }

    // 3. Funções
    constructor() {
        administrador = msg.sender;
    }

    /**
     * Adiciona um novo candidato à votação.
     * Apenas o administrador pode chamar esta função.
     * Não pode adicionar candidatos se a votação já estiver aberta.
     */
    function adicionarCandidato(string memory _nome) public apenasAdmin {
        require(!votacaoAberta, "Nao pode adicionar candidatos com a votacao aberta.");
        candidatos.push(Candidato(_nome, 0));
    }

    /**
     * Abre ou fecha a votação.
     * Apenas o administrador pode chamar esta função.
     */
    function controlarVotacao(bool _aberta) public apenasAdmin {
        votacaoAberta = _aberta;
    }

    /**
     * Permite que um eleitor vote em um candidato.
     */
    function votar(uint _idCandidato) public apenasAberta {
        require(!eleitoresQueVotaram[msg.sender], "Voce ja votou.");

        require(_idCandidato < candidatos.length, "Candidato invalido.");

        eleitoresQueVotaram[msg.sender] = true;

        candidatos[_idCandidato].contagemVotos++;
    }

    /**
     * Função auxiliar para saber o número total de candidatos.
     * Útil para a demonstração.
     */
    function getTotalCandidatos() public view returns (uint) {
        return candidatos.length;
    }
}