import 'package:flutter/material.dart';
import '../models/course.dart';

final List<Course> coursesData = [
  Course(
    id: 'prog101',
    title: 'Introduction to Programming',
    description: 'Learn the fundamentals of programming with Python',
    imageUrl: 'https://example.com/prog101.jpg',
    primaryColor: Colors.blue,
    topics: [
      Topic(
        id: 'prog101_basics',
        title: 'Programming Basics',
        lessons: [
          Lesson(
            id: 'prog101_basics_intro',
            title: 'What is Programming?',
            content: '''
Programming is the process of creating a set of instructions that tell a computer how to perform a task. These instructions are called programs, and they are written using programming languages.

In this course, we'll learn programming using Python, one of the most popular and beginner-friendly programming languages. Python is used in various fields, from web development to data science and artificial intelligence.
''',
            objectives: [
              'Understand what programming is and why it\'s important',
              'Learn about different programming languages and their uses',
              'Get familiar with basic programming concepts',
              'Write your first Python program',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'prog101_basics_intro_video',
                type: 'Video',
                description: '''
An engaging animated video that visualizes how computers execute instructions:
- Shows a simple analogy of programming using a recipe
- Demonstrates how computers process instructions step by step
- Highlights the difference between human languages and programming languages
- Features interactive pause points where users can predict what happens next
''',
                configuration: {
                  'duration': '5:30',
                  'hasInteractivePoints': true,
                  'interactivePoints': [
                    {'timestamp': 120, 'type': 'prediction'},
                    {'timestamp': 240, 'type': 'quiz'},
                  ],
                },
              ),
              InteractiveElement(
                id: 'prog101_basics_intro_simulation',
                type: 'Simulation',
                description: '''
An interactive simulation where users can:
- Drag and drop basic instructions to create a simple program
- Watch how each instruction affects a virtual character
- Experiment with different instruction combinations
- See immediate visual feedback of their program execution
- Debug their program when it doesn't work as expected
''',
                configuration: {
                  'instructions': ['move_forward', 'turn_left', 'turn_right', 'pick_up', 'drop'],
                  'gridSize': 5,
                  'difficulty': 'beginner',
                },
              ),
            ],
          ),
          Lesson(
            id: 'prog101_basics_variables',
            title: 'Variables and Data Types',
            content: '''
Variables are containers for storing data values. Think of them as labeled boxes where you can store different types of information.

In Python, you don't need to declare the type of a variable when you create one. Python automatically determines the variable type based on the value you assign to it.
''',
            objectives: [
              'Understand what variables are and how they work',
              'Learn about different data types in Python',
              'Practice creating and using variables',
              'Master type conversion and variable naming conventions',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'prog101_basics_variables_playground',
                type: 'Interactive Code',
                description: '''
A split-screen interactive coding environment where:
- Left side shows Python code with variables
- Right side shows a visual representation of memory
- Users can type and modify variable values
- Memory visualization updates in real-time
- Includes guided exercises with increasing complexity
- Features instant feedback and hints
''',
                configuration: {
                  'initialCode': 'name = "Alice"\nage = 25\nheight = 1.75',
                  'exercises': [
                    {'type': 'string_manipulation', 'difficulty': 'easy'},
                    {'type': 'number_operations', 'difficulty': 'medium'},
                  ],
                },
              ),
            ],
          ),
        ],
      ),
      Topic(
        id: 'prog101_control',
        title: 'Control Flow',
        lessons: [
          Lesson(
            id: 'prog101_control_conditionals',
            title: 'Conditional Statements',
            content: '''
Conditional statements allow your program to make decisions based on certain conditions. They help your program take different actions depending on whether a condition is true or false.

In Python, we use if, elif, and else statements to create conditional logic.
''',
            objectives: [
              'Understand boolean expressions and comparison operators',
              'Master if-elif-else statements',
              'Learn about nested conditions',
              'Practice writing complex conditional logic',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'prog101_control_conditionals_game',
                type: 'Game',
                description: '''
An interactive game where players guide a character through a maze using conditional logic:
- Players write conditions to control character movement
- Visual feedback shows condition evaluation in real-time
- Multiple paths require different conditional statements
- Progressive difficulty with more complex conditions
- Includes challenges that teach nested conditions
- Features a built-in debugger for finding logical errors
''',
                configuration: {
                  'levels': 5,
                  'difficulty': 'progressive',
                  'features': ['debugger', 'hints', 'solutions'],
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  Course(
    id: 'dsa101',
    title: 'Data Structures & Algorithms',
    description: 'Master the essential data structures and algorithms for efficient programming',
    imageUrl: 'https://example.com/dsa101.jpg',
    primaryColor: Colors.green,
    topics: [
      Topic(
        id: 'dsa101_arrays',
        title: 'Arrays and Lists',
        lessons: [
          Lesson(
            id: 'dsa101_arrays_intro',
            title: 'Introduction to Arrays',
            content: '''
Arrays are one of the most fundamental data structures in computer science. They store elements in contiguous memory locations, allowing for efficient access and manipulation of data.

In this lesson, we'll explore how arrays work, their advantages and limitations, and when to use them in your programs.
''',
            objectives: [
              'Understand what arrays are and how they work in memory',
              'Learn about array operations and their time complexity',
              'Master array traversal and manipulation techniques',
              'Implement common array algorithms',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'dsa101_arrays_memory_viz',
                type: 'Memory Visualization',
                description: '''
An interactive memory visualization tool that shows:
- How arrays are stored in memory
- Memory allocation and deallocation
- Element access patterns and their efficiency
- Comparison with other data structures
- Real-time visualization of array operations
- Memory address calculations and pointer arithmetic
''',
                configuration: {
                  'memorySize': 64,
                  'elementSize': 4,
                  'showAddresses': true,
                  'operations': ['insert', 'delete', 'access', 'resize'],
                },
              ),
              InteractiveElement(
                id: 'dsa101_arrays_practice',
                type: 'Interactive Exercise',
                description: '''
A series of hands-on exercises where users:
- Implement array operations from scratch
- Solve array-based coding problems
- Visualize their solution's execution
- Analyze time and space complexity
- Compare different solution approaches
- Get real-time feedback and optimization suggestions
''',
                configuration: {
                  'exercises': [
                    {'type': 'implementation', 'difficulty': 'easy'},
                    {'type': 'problem_solving', 'difficulty': 'medium'},
                    {'type': 'optimization', 'difficulty': 'hard'},
                  ],
                },
              ),
            ],
          ),
          Lesson(
            id: 'dsa101_arrays_searching',
            title: 'Searching Arrays',
            content: '''
Searching is a fundamental operation in computer science. In this lesson, we'll explore different techniques for searching elements in arrays, from simple linear search to more efficient binary search.

We'll analyze the time complexity of each approach and learn when to use which technique.
''',
            objectives: [
              'Understand different search algorithms',
              'Implement linear and binary search',
              'Analyze search algorithm complexity',
              'Choose the right search algorithm for different scenarios',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'dsa101_arrays_search_viz',
                type: 'Algorithm Visualization',
                description: '''
An interactive visualization that demonstrates:
- Linear search step-by-step execution
- Binary search divide-and-conquer approach
- Comparison of search algorithms' performance
- Animation of search patterns and element comparisons
- User-controlled execution speed
- Custom input array creation and testing
''',
                configuration: {
                  'algorithms': ['linear_search', 'binary_search'],
                  'arraySize': 16,
                  'animationSpeed': 'adjustable',
                  'interactiveMode': true,
                },
              ),
            ],
          ),
        ],
      ),
      Topic(
        id: 'dsa101_linked_lists',
        title: 'Linked Lists',
        lessons: [
          Lesson(
            id: 'dsa101_linked_lists_intro',
            title: 'Understanding Linked Lists',
            content: '''
Linked Lists are dynamic data structures that store elements in nodes, where each node points to the next node in the sequence. Unlike arrays, linked lists don't require contiguous memory allocation.

We'll explore the different types of linked lists and their applications.
''',
            objectives: [
              'Understand the concept of linked lists',
              'Learn about singly and doubly linked lists',
              'Master linked list operations',
              'Compare linked lists with arrays',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'dsa101_linked_lists_builder',
                type: 'Interactive Builder',
                description: '''
A dynamic linked list builder where users can:
- Create nodes and connect them
- Visualize pointer connections
- Perform operations like insertion and deletion
- See memory allocation in real-time
- Compare with array-based implementation
- Practice common linked list algorithms
Features include:
- Drag-and-drop node creation
- Animated pointer updates
- Memory usage visualization
- Step-by-step operation execution
''',
                configuration: {
                  'listTypes': ['singly', 'doubly', 'circular'],
                  'operations': ['insert', 'delete', 'traverse', 'reverse'],
                  'visualMode': '2D',
                  'showMemory': true,
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  Course(
    id: 'web101',
    title: 'Web Development Fundamentals',
    description: 'Learn modern web development with HTML, CSS, and JavaScript',
    imageUrl: 'https://example.com/web101.jpg',
    primaryColor: Colors.orange,
    topics: [
      Topic(
        id: 'web101_html',
        title: 'HTML Essentials',
        lessons: [
          Lesson(
            id: 'web101_html_intro',
            title: 'Introduction to HTML',
            content: '''
HTML (HyperText Markup Language) is the standard markup language for creating web pages. It defines the structure and content of web pages using various elements and attributes.

In this lesson, we'll learn about the basic building blocks of HTML and how to create well-structured web pages.
''',
            objectives: [
              'Understand the role of HTML in web development',
              'Learn about HTML elements and attributes',
              'Create properly structured HTML documents',
              'Master semantic HTML for better accessibility',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'web101_html_playground',
                type: 'Code Editor',
                description: '''
An interactive HTML editor with real-time preview:
- Split-screen layout with code and preview panels
- Syntax highlighting and auto-completion
- Live preview updates as you type
- Built-in HTML validation
- Interactive element inspector
- Accessibility checker highlighting semantic issues
Features:
- Drag and drop elements from a component library
- Visual DOM tree representation
- Device preview modes (desktop, tablet, mobile)
- Code formatting and linting
''',
                configuration: {
                  'mode': 'html',
                  'features': [
                    'preview',
                    'validation',
                    'inspector',
                    'accessibility',
                  ],
                  'templates': ['basic', 'article', 'form'],
                },
              ),
            ],
          ),
          Lesson(
            id: 'web101_html_forms',
            title: 'HTML Forms and Input',
            content: '''
Forms are essential components of interactive websites, allowing users to input data and interact with web applications. HTML provides various form elements for different types of user input.

We'll explore how to create user-friendly forms and handle different types of input data.
''',
            objectives: [
              'Create and structure HTML forms',
              'Use different input types effectively',
              'Implement form validation',
              'Enhance form accessibility',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'web101_html_forms_builder',
                type: 'Form Builder',
                description: '''
An interactive form builder that allows users to:
- Drag and drop form elements onto a canvas
- Configure element properties and validation rules
- Preview form behavior in real-time
- Test form submission and validation
- View generated HTML code
- Analyze form accessibility
Features:
- Visual form element library
- Real-time form preview
- Custom validation rules builder
- Accessibility checker
- Mobile responsiveness testing
- Form submission simulation
''',
                configuration: {
                  'elements': [
                    'text',
                    'email',
                    'password',
                    'checkbox',
                    'radio',
                    'select',
                    'textarea',
                  ],
                  'validationTypes': [
                    'required',
                    'pattern',
                    'length',
                    'custom',
                  ],
                },
              ),
            ],
          ),
        ],
      ),
      Topic(
        id: 'web101_css',
        title: 'CSS Styling',
        lessons: [
          Lesson(
            id: 'web101_css_intro',
            title: 'Introduction to CSS',
            content: '''
CSS (Cascading Style Sheets) is used to control the visual presentation of HTML elements. It allows you to define colors, layouts, animations, and more.

In this lesson, we'll learn the fundamentals of CSS and how to style web pages effectively.
''',
            objectives: [
              'Understand CSS syntax and selectors',
              'Learn about the CSS box model',
              'Master color and typography styling',
              'Implement responsive layouts',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'web101_css_playground',
                type: 'Style Editor',
                description: '''
An interactive CSS playground featuring:
- Visual property editor with live preview
- Color picker with palette management
- Box model visualizer
- Flexbox and Grid layout builders
- Animation timeline editor
- Responsive design tools
Interactive elements include:
- Drag-to-adjust numerical values
- Visual gradient editor
- Transform manipulation handles
- Animation keyframe editor
- Media query breakpoint visualizer
''',
                configuration: {
                  'features': [
                    'visual_editor',
                    'code_editor',
                    'layout_tools',
                    'animation_editor',
                  ],
                  'presets': [
                    'basic_styles',
                    'layouts',
                    'animations',
                  ],
                },
              ),
              InteractiveElement(
                id: 'web101_css_challenges',
                type: 'Interactive Challenges',
                description: '''
A series of CSS challenges where users:
- Solve real-world styling problems
- Complete partially styled layouts
- Debug common CSS issues
- Optimize CSS performance
- Implement responsive designs
Features:
- Progressive difficulty levels
- Real-time feedback
- Multiple solution approaches
- Performance metrics
- Cross-browser testing simulation
''',
                configuration: {
                  'challengeTypes': [
                    'layout',
                    'styling',
                    'animation',
                    'responsive',
                  ],
                  'difficulty': 'progressive',
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  Course(
    id: 'ml101',
    title: 'Introduction to Machine Learning',
    description: 'Learn the fundamentals of machine learning and artificial intelligence',
    imageUrl: 'https://example.com/ml101.jpg',
    primaryColor: Colors.purple,
    topics: [
      Topic(
        id: 'ml101_basics',
        title: 'Machine Learning Basics',
        lessons: [
          Lesson(
            id: 'ml101_basics_intro',
            title: 'What is Machine Learning?',
            content: '''
Machine Learning is a subset of artificial intelligence that focuses on developing systems that can learn and improve from experience without being explicitly programmed.

In this lesson, we'll explore the fundamental concepts of machine learning and its applications in solving real-world problems.
''',
            objectives: [
              'Understand the basic concepts of machine learning',
              'Learn about different types of machine learning',
              'Explore real-world applications',
              'Understand the machine learning workflow',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'ml101_basics_viz',
                type: 'Interactive Visualization',
                description: '''
An interactive visualization system that demonstrates:
- Different types of machine learning through visual examples
- Real-time data processing and model training
- Interactive decision boundary manipulation
- Feature space exploration
Features:
- 2D and 3D visualization modes
- Adjustable parameters
- Real-time model updates
- Dataset manipulation tools
- Performance metrics display
''',
                configuration: {
                  'visualizationTypes': [
                    'classification',
                    'regression',
                    'clustering',
                  ],
                  'interactiveFeatures': [
                    'parameter_tuning',
                    'data_generation',
                    'model_evaluation',
                  ],
                },
              ),
            ],
          ),
          Lesson(
            id: 'ml101_basics_supervised',
            title: 'Supervised Learning',
            content: '''
Supervised learning is a type of machine learning where the model learns from labeled training data. The goal is to learn a mapping from inputs to outputs based on example input-output pairs.

We'll explore various supervised learning algorithms and their applications.
''',
            objectives: [
              'Understand supervised learning concepts',
              'Learn about classification and regression',
              'Explore common algorithms',
              'Practice with real datasets',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'ml101_supervised_playground',
                type: 'Algorithm Playground',
                description: '''
An interactive machine learning playground where users can:
- Load and explore different datasets
- Train various supervised learning models
- Visualize decision boundaries
- Adjust model parameters
- Compare algorithm performance
Features:
- Real-time model training
- Interactive parameter tuning
- Performance visualization
- Cross-validation tools
- Model comparison dashboard
- Feature importance analysis
''',
                configuration: {
                  'algorithms': [
                    'linear_regression',
                    'logistic_regression',
                    'decision_tree',
                    'random_forest',
                    'svm',
                  ],
                  'datasets': [
                    'iris',
                    'boston_housing',
                    'mnist',
                  ],
                  'visualizations': [
                    'learning_curves',
                    'decision_boundaries',
                    'feature_importance',
                  ],
                },
              ),
            ],
          ),
        ],
      ),
      Topic(
        id: 'ml101_neural_networks',
        title: 'Neural Networks',
        lessons: [
          Lesson(
            id: 'ml101_neural_intro',
            title: 'Introduction to Neural Networks',
            content: '''
Neural Networks are computing systems inspired by biological neural networks. They can learn to perform tasks by considering examples, generally without being programmed with task-specific rules.

We'll explore the basic concepts of neural networks and how they work.
''',
            objectives: [
              'Understand neural network architecture',
              'Learn about neurons and activation functions',
              'Master backpropagation concepts',
              'Build your first neural network',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'ml101_neural_builder',
                type: 'Network Builder',
                description: '''
An interactive neural network builder that allows users to:
- Design network architectures by adding layers
- Choose activation functions
- Set learning parameters
- Train networks on various datasets
- Visualize training progress
Features:
- Drag-and-drop layer construction
- Real-time weight visualization
- Activation pattern display
- Learning process animation
- Error backpropagation visualization
- Performance monitoring tools
''',
                configuration: {
                  'layerTypes': [
                    'input',
                    'dense',
                    'activation',
                    'dropout',
                  ],
                  'activationFunctions': [
                    'relu',
                    'sigmoid',
                    'tanh',
                    'softmax',
                  ],
                  'visualizations': [
                    'network_graph',
                    'weight_heatmap',
                    'activation_patterns',
                    'learning_curves',
                  ],
                },
              ),
              InteractiveElement(
                id: 'ml101_neural_playground',
                type: 'Training Playground',
                description: '''
An interactive environment for training neural networks:
- Choose from various datasets and tasks
- Experiment with different architectures
- Visualize training progress in real-time
- Analyze model behavior and performance
Features:
- Multiple dataset options
- Architecture templates
- Parameter experimentation
- Performance visualization
- Model debugging tools
- Export trained models
''',
                configuration: {
                  'datasets': [
                    'mnist',
                    'cifar10',
                    'fashion_mnist',
                  ],
                  'templates': [
                    'basic_mlp',
                    'simple_cnn',
                    'autoencoder',
                  ],
                  'metrics': [
                    'accuracy',
                    'loss',
                    'confusion_matrix',
                  ],
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  Course(
    id: 'mobile101',
    title: 'Mobile App Development',
    description: 'Learn to build beautiful and responsive mobile apps with Flutter',
    imageUrl: 'https://example.com/mobile101.jpg',
    primaryColor: Colors.cyan,
    topics: [
      Topic(
        id: 'mobile101_basics',
        title: 'Flutter Fundamentals',
        lessons: [
          Lesson(
            id: 'mobile101_basics_intro',
            title: 'Introduction to Flutter',
            content: '''
Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.

In this lesson, we'll explore the fundamentals of Flutter and understand its key concepts.
''',
            objectives: [
              'Understand Flutter architecture',
              'Learn about widgets and their types',
              'Master the widget tree concept',
              'Create your first Flutter app',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'mobile101_widget_playground',
                type: 'Widget Explorer',
                description: '''
An interactive widget playground that allows users to:
- Explore different Flutter widgets
- Modify widget properties in real-time
- See immediate visual feedback
- Understand widget tree hierarchy
Features:
- Live property editor
- Widget tree visualizer
- Hot reload simulation
- Layout guide overlays
- Responsive design tools
- Theme customization
''',
                configuration: {
                  'categories': [
                    'basic',
                    'layout',
                    'material',
                    'cupertino',
                  ],
                  'features': [
                    'property_editor',
                    'tree_view',
                    'preview',
                  ],
                },
              ),
            ],
          ),
          Lesson(
            id: 'mobile101_layout',
            title: 'Flutter Layout System',
            content: '''
Flutter's layout system is based on widgets that can be composed to create complex user interfaces. Understanding how to work with layouts is crucial for building responsive and beautiful apps.

We'll explore the most important layout widgets and learn how to combine them effectively.
''',
            objectives: [
              'Master Flutter\'s layout system',
              'Learn about constraints and their propagation',
              'Understand different layout widgets',
              'Build responsive layouts',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'mobile101_layout_builder',
                type: 'Layout Builder',
                description: '''
An interactive layout building environment where users can:
- Drag and drop layout widgets
- Adjust constraints and parameters
- See real-time layout updates
- Debug layout issues
Features:
- Visual constraint editor
- Layout error highlighting
- Responsive preview modes
- Layout animation tools
- Custom constraint testing
- Performance overlay
''',
                configuration: {
                  'widgets': [
                    'container',
                    'row',
                    'column',
                    'stack',
                    'expanded',
                    'flexible',
                  ],
                  'tools': [
                    'inspector',
                    'constraint_viewer',
                    'performance_overlay',
                  ],
                },
              ),
              InteractiveElement(
                id: 'mobile101_layout_challenges',
                type: 'Layout Challenges',
                description: '''
A series of interactive layout challenges where users:
- Recreate common UI patterns
- Solve layout puzzles
- Fix layout issues
- Optimize layout performance
Features:
- Progressive difficulty levels
- Real-time feedback
- Visual comparison tools
- Performance metrics
- Solution hints
- Code generation
''',
                configuration: {
                  'challengeTypes': [
                    'recreation',
                    'debugging',
                    'optimization',
                  ],
                  'difficulty': 'progressive',
                  'features': [
                    'hints',
                    'solutions',
                    'metrics',
                  ],
                },
              ),
            ],
          ),
        ],
      ),
      Topic(
        id: 'mobile101_state',
        title: 'State Management',
        lessons: [
          Lesson(
            id: 'mobile101_state_intro',
            title: 'Understanding State',
            content: '''
State management is a crucial concept in Flutter development. It determines how data flows through your application and how the UI updates in response to changes.

We'll explore different state management approaches and learn when to use each one.
''',
            objectives: [
              'Understand what state is',
              'Learn different types of state',
              'Master setState and StatefulWidget',
              'Explore advanced state management',
            ],
            interactiveElements: [
              InteractiveElement(
                id: 'mobile101_state_simulator',
                type: 'State Simulator',
                description: '''
An interactive state management simulator that:
- Visualizes data flow in Flutter apps
- Demonstrates different state management solutions
- Shows widget rebuilds in real-time
- Helps understand state scoping
Features:
- Live state updates
- Widget rebuild highlighting
- Performance comparison
- State tree visualization
- Data flow animation
- Debug tools integration
''',
                configuration: {
                  'solutions': [
                    'setState',
                    'provider',
                    'bloc',
                    'riverpod',
                  ],
                  'visualizations': [
                    'widget_tree',
                    'state_flow',
                    'rebuild_tracking',
                  ],
                },
              ),
              InteractiveElement(
                id: 'mobile101_state_exercises',
                type: 'State Exercises',
                description: '''
Hands-on exercises for practicing state management:
- Implement different state solutions
- Debug state-related issues
- Optimize state updates
- Handle complex state scenarios
Features:
- Interactive code editor
- Real-time preview
- State flow visualization
- Performance profiling
- Solution validation
- Best practices checker
''',
                configuration: {
                  'exercises': [
                    'counter_app',
                    'todo_list',
                    'shopping_cart',
                    'auth_flow',
                  ],
                  'tools': [
                    'debugger',
                    'profiler',
                    'validator',
                  ],
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  // More courses will be added in subsequent updates
]; 