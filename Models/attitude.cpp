#include <iostream>
#include <cstdint>
#include <vector>
#include <random>
#include <iomanip>
#include <string>
#include <chrono>
#include <sstream>
#include <cstddef>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

namespace mas {
template <typename T>
struct vec2 {
    T x;
    T y;

    auto str() const -> std::string {
        std::stringstream ss;
        ss << "vec2 { ";
        ss << "x: " << x << ", ";
        ss << "y: " << y;
        ss << " }";
        return ss.str();
    }
};

using vec2f = vec2<double>;
using vec2us = vec2<std::size_t>;

auto lerp(double a, double b, double ratio) -> double {
    return (1.0 - ratio) * a + ratio * b;
}

template <typename T>
class heatmap {
  public:
    heatmap(std::size_t const& width, std::size_t const& height)
        : m_width(width), m_height(height) {
        m_data.reserve(m_width * m_height);
    }

    template <typename callable>
    auto init(callable fn) {
        std::generate_n(std::begin(m_data), m_width * m_height, [&] {
            return fn();
        });
    }
    auto data() -> std::vector<T>& { return m_data; }

    auto set(std::size_t x, std::size_t y, T value) -> bool {
        if (x > m_width - 1 || y > m_height - 1)
            return false;

        auto i = y * m_width + x;
        m_data[i] = value;
        return true;
    }

    auto center() -> vec2us {
        vec2f sum{};
        auto sum_mass = 0.0;
        for (std::size_t i = 0; i < m_height; i++) {
            for (std::size_t j = 0; j < m_width; j++) {
                auto mass = m_data[i * m_width + j];
                sum.x += double(j) * mass;
                sum.y += double(i) * mass;
                sum_mass += mass;
            }
        }
        if (sum_mass == 0) sum_mass = 1.0;
        return {
            std::size_t(std::round(sum.x / sum_mass)),
            std::size_t(std::round(sum.y / sum_mass))
        };
    }

    auto str(std::size_t const& precision = 3) const -> std::string {
        std::stringstream ss;
        ss << "[\n";
        for (std::size_t i = 0; i < m_height; i++) {
            ss << "  [ ";
            for (std::size_t j = 0; j < m_width; j++) {
                auto index = i * m_height + j;
                ss << std::fixed << std::setprecision(precision) << m_data[index];
                if (j < m_width - 1) ss << ", ";
            }
            ss << " ],\n";
        }
        ss << "]";
        return ss.str();
    }

  private:
    std::size_t m_width;
    std::size_t m_height;

    std::vector<T> m_data{};
};

}

auto main([[maybe_unused]]std::int32_t argc, [[maybe_unused]]char const* argv[]) -> std::int32_t {
    constexpr std::size_t ROWS = 3;
    constexpr std::size_t COLS = 5;
    //constexpr std::size_t AGENT_COUNT = 10;

    //std::random_device rdev{};
    //std::mt19937 rng{rdev()};
    std::mt19937 rng{1};
    std::uniform_real_distribution<double> dist(0.0, 1.0);
    //auto rand_num = [&] {
    //    return dist(rng);
    //};
    mas::heatmap<double> heat{COLS, ROWS};
    //heat.init(rand_num);
    //heat.set(0, 1, 1.0);
    //heat.set(1, 1, 1.0);
    //heat.set(2, 1, 1.0);
    //heat.set(3, 1, 1.0);
    //heat.set(4, 1, 1.0);
    auto start = std::chrono::high_resolution_clock::now();
    auto cofm  = heat.center();
    auto duration = std::chrono::high_resolution_clock::now() - start;
    std::cout << cofm.str() << "\n";
    std::cout << "time: " << std::chrono::duration_cast<std::chrono::nanoseconds>(duration).count() << " ns\n";

    constexpr std::size_t CHANNELS = 3;
    std::uint8_t* heatmap = new std::uint8_t[ROWS * COLS * CHANNELS];
    for (std::size_t i = 0; i < ROWS; i++) {
        for (std::size_t j = 0; j < COLS; j++) {
            auto image_index = i * ROWS * CHANNELS + j * CHANNELS;
            auto index = i * ROWS + j;
            auto gray = static_cast<std::uint8_t>(std::round(heat.data()[index] * 255.0));

            heatmap[image_index + 0] = gray;
            heatmap[image_index + 1] = gray;
            heatmap[image_index + 2] = gray;
        }
    }

    stbi_write_png("./bin/heatmap.png", ROWS, COLS, CHANNELS, heatmap, COLS * CHANNELS);

    delete [] heatmap;

    return 0;
}

