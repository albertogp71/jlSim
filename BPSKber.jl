using Random, Statistics, Printf
using SpecialFunctions

# Function to simulate BPSK transmission with AWGN
function bpsk_simulation(num_bits::Int, EbN0_dB::Float64)
    # 1. Generate random bits (0 or 1)
    bits = rand(0:1, num_bits)
    
    # 2. BPSK modulation: map 0 -> -1, 1 -> +1
    symbols = @. 2*bits - 1

    # 3. Compute noise variance from Eb/N0 (in dB)
    EbN0 = 10^(EbN0_dB/10)
    noise_std = sqrt(1 / (2 * EbN0))

    # 4. Add white Gaussian noise
    noise = randn(num_bits) .* noise_std
    received = symbols + noise

    # 5. Demodulation (threshold detection)
    received_bits = @. ifelse(received > 0, 1, 0)

    # 6. Compute Bit Error Rate
    num_errors = sum(bits .!= received_bits)
    ber = num_errors / num_bits

    return ber
end

# Run simulation for different SNR values
num_bits = 1_000_000
SNR_dBs = 0.:2.:12.
println("SNR(dB)    Simulated BER    Theoretical BER")

for snr in SNR_dBs
    ber_sim = bpsk_simulation(num_bits, snr)
    ber_theory = 0.5 * erfc(sqrt(10^(snr/10)))
    @printf("%6.1f     %1.3e         %1.3e\n", snr, ber_sim, ber_theory)
end
