<h1>Arquitetura do Projeto</h1>

<p>Para este projeto, optei pela arquitetura MVVM-C (Model-View-ViewModel-Coordinator). Essa arquitetura foi escolhida por sua capacidade de separar a lógica de negócios da lógica de UI, o que facilita a manutenção e a testabilidade do código. Além disso, o uso do Coordinator me permitiu gerenciar a navegação entre as telas, mantendo a responsabilidade de roteamento fora das ViewControllers.</p>

<h2>Interface do Usuário</h2>

<p>A interface do usuário foi construída utilizando UITableView e UICollectionView. A UITableView é usada para listar as notícias, enquanto a UICollectionView, que está embutida na UITableView, é usada para exibir notícias na horizontal.</p>

<p>Optei por repetir as notícias na seção horizontal devido a limitações que encontrei durante o desenvolvimento, que me impediram de filtrar e exibir apenas as principais notícias nessa seção. Estou trabalhando para melhorar este aspecto e proporcionar uma experiência de usuário mais rica e diversificada.</p>

<h2>Chave da API</h2>

<p>A chave da API está publicamente disponível neste projeto apenas para fins de teste. Em um cenário real, eu armazenaria a chave da API de forma segura no arquivo <code>config.plist</code> para evitar a exposição de informações sensíveis.</p>

<p>Agradeço a sua compreensão e estou aberto a sugestões e feedbacks para melhorar meu projeto.</p>
