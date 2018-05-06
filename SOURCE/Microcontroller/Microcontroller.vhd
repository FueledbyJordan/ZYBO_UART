library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Microcontroller is
    Port(
        clk : in std_logic;
        sbus : out std_logic_vector(7 downto 0);
        dbus : out std_logic_vector(7 downto 0);
        aluout : out std_logic_vector(7 downto 0);
        immed : out std_logic_vector(7 downto 0);
        aluop : out std_logic_vector(1 downto 0); 
        negative : out std_logic;
        zero : out std_logic;
        pcsel : out std_logic;
        stage : out std_logic_vector(1 downto 0);
        pcload : out std_logic;
        addressout : out std_logic_vector(7 downto 0);
        irlineout : out std_logic_vector(7 downto 0)
    );
end entity;

architecture Behavioral of Microcontroller is

component Register_File is
    Port ( dwrite : in STD_LOGIC;
           dval : in STD_LOGIC_VECTOR (7 downto 0);
           sregsel : in STD_LOGIC_vector (1 downto 0);
           dregsel : in STD_LOGIC_vector (1 downto 0);
           sbus : out STD_LOGIC_VECTOR (7 downto 0);
           dbus : out STD_LOGIC_VECTOR (7 downto 0);
           Zero : out STD_LOGIC;
           Negative : out STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component Decode_Logic is
    port(
        instruction : in std_logic_vector(7 downto 0); --instruction input from IR
        zero : in std_logic; --zero line from Register File; pass to pcload
        negative : in std_logic; --negative from Register File; pass to pcload
        stage : in std_logic_vector(1 downto 0); --input from the stage counter
        addrsel : out std_logic_vector(1 downto 0);
        irload : out std_logic;
        imload : out std_logic;
        regsel: out std_logic_vector(1 downto 0);
        dwrite: out std_logic;
        aluop: out std_logic_vector(1 downto 0);
        readwrite: out std_logic;
        pcsel: out std_logic;
        pcload: out std_logic;
        sregsel: out std_logic_vector(1 downto 0);
        dregsel: out std_logic_vector(1 downto 0)
);
end component;

component PC is
    Port ( Immed_in : in STD_LOGIC_VECTOR (7 downto 0);
           clk : in std_logic;
           pcsel : in std_logic;
           pcload : in std_logic;
           sbus : in std_logic_vector (7 downto 0 );
           dbus : in std_logic_vector (7 downto 0 );
           addrsel  : in std_logic_vector (1 downto 0);
           stage : in std_logic_vector(1 downto 0);
           address : out STD_LOGIC_VECTOR (7 downto 0):="00000000");
end component;

component ALU is
    Port (
        A : in STD_LOGIC_VECTOR(7 downto 0);
        B : in STD_LOGIC_VECTOR(7 downto 0);
        aluop : in STD_LOGIC_VECTOR(1 downto 0);
        result : out STD_LOGIC_VECTOR(7 downto 0)
    );
end component;

component IR_reg is
    Port ( IR_in : in STD_LOGIC_VECTOR (7 downto 0);
           IR_out : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC);
end component;

component Immed_reg is
    Port ( Immed_in : in STD_LOGIC_VECTOR (7 downto 0);
           Immed_out : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           enable : in STD_LOGIC);
end component;

component MEMORY is
    port(
        address : in std_logic_vector(7 downto 0) := "00000000";
        dataout : out std_logic_vector(7 downto 0) := "00000000";
        datain : in std_logic_vector(7 downto 0);
        readwrite : in std_logic;-- := '0';   --read is 1, write is 0
        clk : in std_logic := '0';
        rst : in std_logic := '0'
    );
END COMPONENT;

component Stage_Count is
  Port ( 
  clk, rst: in std_logic;
  stage:    out std_logic_vector(1 downto 0):= "00"
  );
end component;

component mux8 is
    Port ( a: in  STD_LOGIC_VECTOR(7 downto 0);
           b: in  STD_LOGIC_VECTOR(7 downto 0);
           c: in  STD_LOGIC_VECTOR(7 downto 0);
           d: in  STD_LOGIC_VECTOR(7 downto 0);
           s: in  STD_LOGIC_VECTOR(1 downto 0);
      output: out STD_LOGIC_VECTOR(7 downto 0));
end component;

--ALU bus
signal aluoutbus : std_logic_vector(7 downto 0); --output of ALU
--Register Data bus
signal sbusline : std_logic_vector(7 downto 0); --signal for sbus
signal dbusline : std_logic_vector(7 downto 0); --signal for dbus
signal addressbus : std_logic_vector(7 downto 0); --signal for address bus; output of PC block
signal datainbus : std_logic_vector(7 downto 0); --signal for datain; output of memory block
signal middlemux : std_logic_vector(7 downto 0); --output of middle mux
signal zline : std_logic; --signal for zero out of register file
signal nline : std_logic; --signal for negative out of register file
signal reset : std_logic; --signal for reset; not used
signal irline : std_logic_vector(7 downto 0); --signal for output of IR 
signal imline : std_logic_vector(7 downto 0); --signal for output of IM register
--Control Lines
signal addrselline : std_logic_vector(1 downto 0); --addrsel output of decode
signal irloadline : std_logic; --irload output of decode
signal imloadline : std_logic; --imload output of decode
signal regselline : std_logic_vector(1 downto 0); --regsel output of decode
signal dwriteline : std_logic; --dwrite output of decode
signal aluopline : std_logic_vector(1 downto 0); --aluop output of decode
signal readwriteline : std_logic; --readwrite output of decode
signal pcselline : std_logic; -- pcsel output of decode
signal pcloadline : std_logic; --pcload output of decode
signal sregselline : std_logic_vector(1 downto 0); --sregsel output of decode
signal dregselline : std_logic_vector(1 downto 0); --dregsel output of decode
signal stageline : std_logic_vector(1 downto 0); --signal for stage; output of stage counter

begin

Regs: Register_File port map(dwrite=>dwriteline,dval=>middlemux,sregsel=>sregselline,dregsel=>dregselline,sbus=>sbusline,dbus=>dbusline,Zero=>zline,Negative=>nline,clk=>clk,reset=>reset);
Decode: Decode_Logic port map(instruction=>irline,zero=>zline,negative=>nline,stage=>stageline,addrsel=>addrselline,irload=>irloadline,imload=>imloadline,regsel=>regselline,dwrite=>dwriteline,aluop=>aluopline,readwrite=>readwriteline,pcsel=>pcselline,pcload=>pcloadline,sregsel=>sregselline,dregsel=>dregselline);
PCBlock: PC port map(Immed_in=>imline,clk=>clk,pcsel=>pcselline,pcload=>pcloadline,sbus=>sbusline,dbus=>dbusline,addrsel=>addrselline,address=>addressbus,stage=>stageline);
ALUBlock: ALU port map(A=>dbusline,B=>sbusline,aluop=>aluopline,result=>aluoutbus);
IR_reg_block: IR_reg port map(IR_in=>datainbus,IR_out=>irline,clk=>clk,enable=>irloadline);
Immed_reg_block: Immed_reg port map(Immed_in=>datainbus,Immed_out=>imline,clk=>clk,enable=>imloadline);
MemoryBlock: MEMORY port map(address=>addressbus,dataout=>datainbus,datain=>dbusline,readwrite=>readwriteline,clk=>clk,rst=>reset);
StageCounter: Stage_Count port map(clk=>clk,rst=>reset,stage=>stageline);
MiddleMuxBlock: mux8 port map(a=>imline,b=>sbusline,c=>datainbus,d=>aluoutbus,s=>regselline,output=>middlemux);
        
sbus<=sbusline;
dbus<=dbusline;
aluout<=aluoutbus;
immed<=imline;
aluop<=aluopline;
negative<=nline;
zero<=zline;
pcsel<=pcselline;
pcload<=pcloadline;
stage<=stageline;
addressout<=addressbus;
irlineout<=datainbus;

end Behavioral;