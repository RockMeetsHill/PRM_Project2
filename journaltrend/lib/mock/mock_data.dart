import '../models/publication.dart';
import '../models/author.dart';
import '../models/journal.dart';

class MockData {
  static const String topic = "Artificial Intelligence";
  static const int totalPublications = 1240;
  static const double avgCitations = 38.5;
  static const int mostActiveYear = 2023;
  static const String topJournal = "Nature Machine Intelligence";
  static const String topAuthor = "Yann LeCun";

  static const List<Publication> publications = [
    Publication(
      id: "pub_1",
      title: "Deep Learning for Computer Vision: A Comprehensive Survey",
      year: 2018,
      citationCount: 450,
      journalName: "Nature Machine Intelligence",
      authors: ["Yann LeCun", "Yoshua Bengio", "Geoffrey Hinton"],
      doi: "10.1038/s42256-018-0001-1",
      abstract: "Deep learning has revolutionized computer vision by enabling end-to-end learning of feature representations from raw pixel data. In this comprehensive survey, we review the state-of-the-art architectures, training methodologies, and key challenges in the field, outlining future research directions.",
    ),
    Publication(
      id: "pub_2",
      title: "Attention Is All You Need: Transformers in Natural Language Processing",
      year: 2017,
      citationCount: 1250,
      journalName: "IEEE Transactions on Pattern Analysis and Machine Intelligence",
      authors: ["Ashish Vaswani", "Noam Shazeer", "Niki Parmar", "Jakob Uszkoreit"],
      doi: "10.1109/TPAMI.2017.0002",
      abstract: "We propose a new simple network architecture, the Transformer, based solely on attention mechanisms, dispensing with recurrence and convolutions entirely. Experiments on two machine translation tasks show these models to be superior in quality while being more parallelizable.",
    ),
    Publication(
      id: "pub_3",
      title: "Generative Adversarial Nets for Realistic Image Synthesis",
      year: 2015,
      citationCount: 890,
      journalName: "Journal of Artificial Intelligence Research",
      authors: ["Ian Goodfellow", "Jean Pouget-Abadie", "Mehdi Mirza"],
      doi: "10.1613/jair.2015.0003",
      abstract: "We introduce a new framework for estimating generative models via an adversarial process, in which we simultaneously train two models: a generative model that captures the data distribution, and a discriminative model that estimates the probability that a sample came from the training data.",
    ),
    Publication(
      id: "pub_4",
      title: "Reinforcement Learning with Deep Q-Networks in Complex Environments",
      year: 2016,
      citationCount: 620,
      journalName: "Artificial Intelligence Journal",
      authors: ["Volodymyr Mnih", "Koray Kavukcuoglu", "David Silver"],
      doi: "10.1016/j.artint.2016.0004",
      abstract: "We demonstrate that the deep Q-network agent, receiving only pixels and the game score as inputs, was able to surpass the performance of all previous algorithms and achieve a level comparable to that of a professional human games tester across a set of 49 challenging Atari games.",
    ),
    Publication(
      id: "pub_5",
      title: "Graph Neural Networks: A Systematic Review of Methods and Applications",
      year: 2020,
      citationCount: 310,
      journalName: "Neural Networks and Learning Systems",
      authors: ["Thomas Kipf", "Max Welling"],
      doi: "10.1109/TNNLS.2020.0005",
      abstract: "Graph neural networks (GNNs) have recently emerged as a powerful framework for representation learning on graphs. In this article, we provide a systematic review of GNNs, categorizing existing methods into convolutional, recurrent, spatial, and temporal approaches.",
    ),
    Publication(
      id: "pub_6",
      title: "Large Language Models are Few-Shot Learners: Scale and Capabilities",
      year: 2020,
      citationCount: 1100,
      journalName: "Nature Machine Intelligence",
      authors: ["Tom Brown", "Benjamin Mann", "Nick Ryder", "Yann LeCun"],
      doi: "10.1038/s42256-020-0006-y",
      abstract: "We show that scaling up language models greatly improves task-agnostic, few-shot performance, sometimes even reaching competitiveness with prior state-of-the-art fine-tuning approaches. We train GPT-3, an autoregressive language model with 175 billion parameters.",
    ),
    Publication(
      id: "pub_7",
      title: "Contrastive Learning of Visual Representations: Framework and Benchmarks",
      year: 2021,
      citationCount: 280,
      journalName: "IEEE Transactions on Pattern Analysis and Machine Intelligence",
      authors: ["Ting Chen", "Simon Kornblith", "Mohammad Norouzi"],
      doi: "10.1109/TPAMI.2021.0007",
      abstract: "This paper presents SimCLR: a simple framework for contrastive learning of visual representations. We simplify recently proposed contrastive self-supervised learning algorithms without requiring specialized architectures or a memory bank.",
    ),
    Publication(
      id: "pub_8",
      title: "Ethics and Bias in Machine Learning: Challenges and Auditing Tools",
      year: 2022,
      citationCount: 150,
      journalName: "Journal of Artificial Intelligence Research",
      authors: ["Timnit Gebru", "Joy Buolamwini", "Margaret Mitchell"],
      doi: "10.1613/jair.2022.0008",
      abstract: "Machine learning models often inherit and amplify societal biases present in training data. We analyze the ethical implications of automated decision-making and introduce auditing frameworks designed to detect and mitigate bias in predictive models.",
    ),
    Publication(
      id: "pub_9",
      title: "Diffusion Models for High-Fidelity Image Generation",
      year: 2023,
      citationCount: 540,
      journalName: "Nature Machine Intelligence",
      authors: ["Jonathan Ho", "Ajay Jain", "Pieter Abbeel"],
      doi: "10.1038/s42256-023-0009-z",
      abstract: "We present high-quality image synthesis results using diffusion probabilistic models, a class of latent variable models inspired by considerations from non-equilibrium thermodynamics. Our models generate samples that rival GANs and autoregressive models.",
    ),
    Publication(
      id: "pub_10",
      title: "Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks",
      year: 2021,
      citationCount: 410,
      journalName: "Artificial Intelligence Journal",
      authors: ["Patrick Lewis", "Ethan Perez", "Aleksandra Piktus"],
      doi: "10.1016/j.artint.2021.0010",
      abstract: "Large pre-trained language models have been shown to store factual knowledge in their parameters. However, their ability to precisely access and manipulate knowledge is still limited. We introduce retrieval-augmented generation (RAG) to solve this.",
    ),
    Publication(
      id: "pub_11",
      title: "Multimodal Foundation Models: Aligning Text, Vision, and Audio",
      year: 2024,
      citationCount: 95,
      journalName: "Nature Machine Intelligence",
      authors: ["Alec Radford", "Jong Wook Kim", "Chris Hallacy"],
      doi: "10.1038/s42256-024-0011-x",
      abstract: "We explore the training of large-scale foundation models on heterogeneous multimodal datasets. By aligning image embeddings with text and audio representations, we achieve zero-shot transfer capabilities across a diverse range of downstream tasks.",
    ),
    Publication(
      id: "pub_12",
      title: "Blockchain Technology: Principles, Consensus Mechanisms, and Smart Contracts",
      year: 2019,
      citationCount: 750,
      journalName: "Journal of Systems and Software",
      authors: ["Vitalik Buterin", "Satoshi Nakamoto"],
      doi: "10.1016/j.jss.2019.0012",
      abstract: "We present a comprehensive study on blockchain networks, focusing on consensus algorithms like Proof-of-Work (PoW) and Proof-of-Stake (PoS), and analyzing their scalability, security trade-offs, and applications in decentralized finance.",
    ),
    Publication(
      id: "pub_13",
      title: "Internet of Things (IoT) Architectures, Protocols, and Security: A Survey",
      year: 2020,
      citationCount: 520,
      journalName: "IEEE Internet of Things Journal",
      authors: ["Andy Stanford-Clark", "Arlen Nipper"],
      doi: "10.1109/JIOT.2020.0013",
      abstract: "This paper reviews standard architectures and communication protocols (MQTT, CoAP) for the Internet of Things (IoT), while classifying threats and summarizing mitigation strategies at the device, edge, and cloud levels.",
    ),
    Publication(
      id: "pub_14",
      title: "Cybersecurity in the Cloud Era: Threat Detection and Risk Mitigation",
      year: 2021,
      citationCount: 320,
      journalName: "Computers & Security",
      authors: ["Gene Spafford", "Dorothy Denning"],
      doi: "10.1016/j.cose.2021.0014",
      abstract: "As organizations migrate services to public and private clouds, secure resource isolation and network policy management become critical. We evaluate modern intrusion detection systems and zero-trust policies.",
    ),
    Publication(
      id: "pub_15",
      title: "Data Science and Predictive Analytics: Foundations for Decision Making",
      year: 2022,
      citationCount: 480,
      journalName: "Journal of Computational and Graphical Statistics",
      authors: ["Hadley Wickham", "Wes McKinney"],
      doi: "10.1080/jcgs.2022.0015",
      abstract: "This article outlines essential paradigms in modern data science. We explore tidying datasets, structural modeling, and predictive analytical methods designed to process billions of operations with minimal computation overhead.",
    ),
    Publication(
      id: "pub_16",
      title: "Modern Software Engineering: Agile Practices, Microservices, and DevOps",
      year: 2023,
      citationCount: 210,
      journalName: "IEEE Software",
      authors: ["Martin Fowler", "Kent Beck"],
      doi: "10.1109/MS.2023.0016",
      abstract: "We evaluate the shift from monolithic application development to containerized microservices architectures, explaining how test-driven development (TDD) and continuous delivery pipelines improve product quality and deployment velocity.",
    ),
  ];

  static const List<Author> authors = [
    Author(name: "Yann LeCun", paperCount: 42),
    Author(name: "Yoshua Bengio", paperCount: 38),
    Author(name: "Geoffrey Hinton", paperCount: 35),
    Author(name: "David Silver", paperCount: 29),
    Author(name: "Ian Goodfellow", paperCount: 27),
  ];

  static const List<Journal> journals = [
    Journal(name: "Nature Machine Intelligence", publicationCount: 154),
    Journal(name: "IEEE Transactions on Pattern Analysis and Machine Intelligence", publicationCount: 132),
    Journal(name: "Journal of Artificial Intelligence Research", publicationCount: 98),
    Journal(name: "Artificial Intelligence Journal", publicationCount: 87),
    Journal(name: "Neural Networks and Learning Systems", publicationCount: 76),
  ];

  static const Map<int, int> trendData = {
    2015: 45,
    2016: 58,
    2017: 72,
    2018: 90,
    2019: 110,
    2020: 135,
    2021: 160,
    2022: 195,
    2023: 245,
    2024: 130, // Mid-year data
  };

  static Publication get mostInfluentialPaper {
    // Return publication with the highest citation count (which is pub_2, "Attention Is All You Need")
    return publications.reduce((curr, next) => curr.citationCount > next.citationCount ? curr : next);
  }
}
