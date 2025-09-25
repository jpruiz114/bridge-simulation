# Bridge Simulation - ActionScript 3 (Original Version)

An interactive bridge physics simulation built in ActionScript 3 using the spring-mass model. This is the **original version** that inspired the modern HTML5 implementation available at [jeanpaulruizvallejo.com/physics-simulations](https://jeanpaulruizvallejo.com/physics-simulations/).

**Built with FlashDevelop IDE**

## Overview

This ActionScript 3 project demonstrates fundamental concepts in physics simulation, numerical methods, and computational modeling through an interactive bridge visualization. The simulation models a bridge structure as a series of interconnected plates linked by springs, following Hooke's Law principles.

## Physics Implementation

### Core Concepts

- **Spring-Mass System**: Bridge modeled as a 15x5 grid of interconnected plates
- **Hooke's Law**: Spring forces calculated using F = k × (L - L₀) × sign(displacement)
- **Numerical Integration**: Runge-Kutta 4th order method for solving differential equations
- **Real-time Visualization**: 3D isometric rendering with live physics updates

### Mathematical Model

The simulation implements a system of coupled differential equations:

```
ΣF = k×(√(Δx² + (z_{i±1,j±1} - z_{i,j})²) - L₀)×sign(displacement) - K_f×(dz/dt) - m×g = m×(d²z/dt²)
```

Where:
- `k = 200.0` - Spring constant
- `β = 40.0` - Air friction coefficient  
- `m = 5.0` - Mass of each plate
- `L₀ = 0.4` - Natural spring length
- `g = 9.8` - Gravitational acceleration

## Technical Features

### Physics Engine
- **Matrix Operations**: Custom implementations for matrix addition, scalar multiplication
- **Boundary Conditions**: Edge plates remain fixed to simulate structural supports
- **Damping System**: Air friction modeling to prevent infinite oscillation
- **Neighbor Connectivity**: Each plate connects to up to 4 neighbors (2-4 depending on position)

### Visualization
- **3D Isometric Graphics**: Using as3isolib library for real-time 3D rendering
- **Shaded Rendering**: Multiple color fills for realistic depth perception
- **Animation System**: Timer-based updates at 30 FPS with 10ms intervals
- **Real-time Updates**: Live position updates as physics calculations progress

### User Interface
- **Frame Rate Display**: Performance monitoring with FrameRater component
- **Time Display**: Real-time simulation timestamp
- **Minimal UI**: Clean interface focusing on the physics visualization

## Project Structure

```
bridge-simulation/
├── src/
│   ├── Simulacion_puente_03.as          # Main simulation class
│   ├── as3isolib/                        # 3D isometric graphics library
│   ├── com/bit101/components/            # MinimalComps UI library
│   ├── de/polygonal/ds/                  # Data structures library
│   ├── eDpLib/events/                    # Event handling utilities
│   └── assets/                           # Font assets
├── bin-debug/                            # Debug build output
├── bin-release/                          # Release build output
└── html-template/                        # HTML wrapper templates
```

## Development Environment

### Requirements
- **Adobe Flash Player 10+**
- **FlashDevelop IDE** (recommended)
- **Adobe Flex SDK**

### Building the Project
1. Open `Simulacion_puente_03.as3proj` in FlashDevelop
2. Build project (F8) to generate SWF
3. Test movie (F5) to run simulation

### Libraries Used
- **as3isolib**: 3D isometric graphics and scene management
- **MinimalComps**: UI components (Labels, FrameRater)
- **Polygonal DS**: Advanced data structures
- **Custom Physics Engine**: Matrix operations and numerical integration

## Legacy and Evolution

This ActionScript 3 simulation represents the foundational work that led to the development of a modern, web-based physics simulation platform. The concepts, algorithms, and mathematical models developed here were later reimplemented in HTML5/JavaScript, resulting in the comprehensive physics simulation suite available at:

- **Main Project**: [Physics Simulations](https://github.com/jpruiz114/physics-simulations)
- **Live Demo**: [Bridge Simulation](https://jeanpaulruizvallejo.com/physics-simulations/bridge-simulation-spring-mass-model/)

The modern HTML5 version includes:
- Enhanced mathematical documentation with KaTeX rendering
- Interactive parameter controls
- Improved 3D visualization with Isomer.js
- Responsive web design
- Educational content and hand-worked solutions

## Key Algorithms

### Runge-Kutta 4th Order Integration
```actionscript
// Implemented in fn_manejadorTimer method
var k1:Array = f(t, gaMatrizX);
var k2:Array = f(t + h/2, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k1, h*0.5)));
var k3:Array = f(t + h/2, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k2, h*0.5)));
var k4:Array = f(t + h, fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k3, h)));

// Update solution
gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k1, h/6));
gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k2, 2*h/6));
gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k3, 2*h/6));
gaMatrizX = fn_sumarMatrices(gaMatrizX, fn_multiplicarMatrizPorNumero(k4, h/6));
```

### Spring Force Calculation
```actionscript
// Force between connected plates using extended Hooke's Law
d = k * (Math.sqrt(Math.pow(distance, 2) + Math.pow(displacement, 2)) - Lo) * fn_signo(displacement);
```

## Historical Context

This project was developed during the Adobe Flash era as an educational tool to demonstrate:
- Advanced ActionScript 3 programming techniques
- Real-time physics simulation in Flash
- 3D graphics rendering without hardware acceleration
- Numerical methods implementation from scratch

While Flash technology is now deprecated, the mathematical foundations and algorithmic approaches developed in this project remain relevant and have been successfully translated to modern web technologies.

## Educational Value

The original ActionScript 3 implementation serves as an excellent reference for:
- Understanding physics simulation from first principles
- Learning numerical integration techniques
- Implementing matrix operations from scratch
- Real-time animation and rendering concepts
- Migration strategies from legacy to modern web technologies

## References

- **Modern HTML5 Version**: [https://github.com/jpruiz114/physics-simulations](https://github.com/jpruiz114/physics-simulations)
- **Live Demo**: [https://jeanpaulruizvallejo.com/physics-simulations/](https://jeanpaulruizvallejo.com/physics-simulations/)
- **FlashDevelop IDE**: [http://www.flashdevelop.org/](http://www.flashdevelop.org/)
- **as3isolib Library**: 3D isometric graphics library for ActionScript 3

## License

This project is available for educational and research purposes. The mathematical models and algorithms have been reimplemented in the modern HTML5 version linked above.

---

*This ActionScript 3 simulation laid the groundwork for understanding physics-based modeling that continues to evolve in modern web technologies.*