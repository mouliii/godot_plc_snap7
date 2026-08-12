#pragma once
#include "snap7.h"
#include <godot_cpp/classes/node.hpp>
#include <godot_cpp/variant/string.hpp>

using namespace godot;

class Snap7Wrapper: public Node
{
	GDCLASS(Snap7Wrapper, Node);
public:
enum DATA_TYPE{
	BOOL = 0,
	INT = 1,
	WORD = 2,
	REAL = 3,
	//STRING = 4
};

enum MEM_AREA {
	INPUT_DONT_USE = 0x81, //NOT WORK,PLC's IMAGE PROCESS TABLE CLEARS EVERY LOOP START
	OUTPUT = 0x82,
	M_MEM = 0x83,
	DATA_BLOCK = 0x84,
	COUNTER_NYI = 0x1C,
	TIMER_NYI = 0x1D
};

public:
	Snap7Wrapper() = default;
	~Snap7Wrapper() override = default;
	int ConnectToPLC(String ip, int rack, int slot);
	int IsConnected();
	int WritePlc(MEM_AREA area, DATA_TYPE dataType, int db, int offset, int bit, Variant value);
	Variant ReadPlc(MEM_AREA area, DATA_TYPE dataType, int db, int offset, int bit);
	int GetDataSize(DATA_TYPE dt);
	Variant GetValueFromBuffer(DATA_TYPE dt, int offset, int bit);
	void SetPollRate(float val);
	float GetPollRate();
	void SetAnalogMax(int val);
	int GetAnalogMax();
	void SetIp(String ip);
	String GetIp();

	void Test();

private:
	static uint32_t swapEndianF(float val);

public:
	float pollRate = 0.1f;
	int analogValueMax = 27648;
	String ipAddress = "192.168.0.90";

private:
	TS7Client client;
	byte buffer[64];

protected:
	static void _bind_methods();
};

VARIANT_ENUM_CAST(Snap7Wrapper::DATA_TYPE);
VARIANT_ENUM_CAST(Snap7Wrapper::MEM_AREA);
