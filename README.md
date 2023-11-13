# Smart-Irrigation-System
Smart Irrigation System using PIC18F6620, Water pumps and Relays. This project is a microcontroller-based moisture control system that controls three pumps based on the analog input from three sensors and displays the pump status on  seven segment displays. The system is controlled using assembly language and the pumps are connected to pins B5, B6, and B7, respectively. The analog sensors are connected to pins AN0, AN1, and AN2. When the moisture level is below a certain threshold, the corresponding pump is turned on, and its status is displayed as "ON" on the seven segment display using pins D0, D1, and D2. The threshold is detected using the analog input by determining the voltage value from the moisture sensor. The system also includes a delay subroutine for the delays required in the system which is set to 1 second and a switch interrupt service routine for the emergency stop button and restart button. This project is suitable for applications where precise moisture control and pump monitoring are required, such as in irrigation systems, hydroponics setups, or plant growth chambers using microcontrollers as its processing system.

## Circuit in Proteus Software
![Alt text](https://github.com/FlameCerberus/Smart-Irrigation-System/blob/main/CircuitInProteusSS.png)

## Subroutine Delay Calculation
P𝑒𝑟𝑖𝑜𝑑=1/32𝑀=31.25𝑛𝑠

1 𝐼𝑛𝑠𝑡𝑟𝑢𝑐𝑡𝑖𝑜𝑛 = 4 𝑝𝑒𝑟𝑖𝑜𝑑 = 125 𝑛𝑠

𝑇𝑜𝑡𝑎𝑙 𝐼𝑛𝑠𝑡𝑟𝑢𝑐𝑡𝑖𝑜𝑛 𝑓𝑜𝑟 2𝑠=1𝑠/125𝑛𝑠=8000000

8𝑀=(247+3 𝑖𝑛𝑠𝑡𝑟𝑢𝑐𝑡𝑖𝑜𝑛)∗250∗128

## Tacq Calculation
𝑇_𝐴𝐷>1.6𝜇𝑠 𝑏𝑒𝑐𝑎𝑢𝑠𝑒 𝑜𝑓 64𝑇_𝑂𝑆𝐶 𝑅𝑒𝑞𝑢𝑖𝑟𝑒𝑑 𝑎𝑐𝑞𝑢𝑖𝑠𝑖𝑜𝑛 𝑡𝑖𝑚𝑒 𝑖𝑠 𝑇_𝐴𝐶𝑄=2𝜇𝑠+9.61𝜇𝑠+[(𝑇𝑒𝑚𝑝−25^𝑜 𝐶)(0.05𝜇𝑠/𝑜𝐶)]

𝐴𝑠𝑠𝑢𝑚𝑒 𝑅𝑜𝑜𝑚 𝑇𝑒𝑚𝑝𝑒𝑟𝑎𝑡𝑢𝑟𝑒, 25^𝑜𝐶 

𝑇_𝐴𝐶𝑄=2𝜇𝑠+9.61𝜇𝑠

𝑇_𝐴𝐶𝑄=11.61𝜇𝑠
