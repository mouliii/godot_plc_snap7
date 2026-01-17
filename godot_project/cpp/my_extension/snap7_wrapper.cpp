#include "snap7_wrapper.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/core/class_db.hpp>

int Snap7Wrapper::ConnectToPLC(String ip, int rack, int slot) {
	std::string sip = ip.utf8().get_data(); 
	return client.ConnectTo(sip.c_str(), rack, slot);
}

int Snap7Wrapper::IsConnected() {
	return client.Connected();
}

int Snap7Wrapper::WritePlc(MEM_AREA area, DATA_TYPE dataType, int db, int offset, int bit, Variant value) {
	if (!IsConnected()) {
		return -1;
	}
	switch (dataType) {
		case Snap7Wrapper::BOOL:
		{
			bool bVal = ReadPlc(area, dataType, db, offset, bit);
			if (value) {
				buffer[0] |= (1 << bit);
			} else {
				buffer[0] &= ~(1 << bit);
			}
			int status = client.WriteArea(area, db, offset, GetDataSize(dataType), S7WLByte, buffer);
			break;
		}
		case Snap7Wrapper::INT:
		case Snap7Wrapper::WORD:
		{
			int16_t iVal = value;
			iVal = _byteswap_ushort(iVal);
			std::memcpy(buffer, &iVal, sizeof(iVal));
			client.WriteArea(area, db, offset, GetDataSize(dataType), S7WLByte, buffer);
			break;
		}
		case Snap7Wrapper::REAL:
		{
			int32_t uValue = swapEndianF(value);
			std::memcpy(buffer, &uValue, sizeof(uValue));
			client.WriteArea(area, db, offset, GetDataSize(dataType), S7WLByte, buffer);
			break;
		}
		default:
			break;
	}
	return -1;
}

Variant Snap7Wrapper::ReadPlc(MEM_AREA area, DATA_TYPE dataType, int db, int offset, int bit) {
	if (!IsConnected()) {
		return Variant();
	}
	int size = GetDataSize(dataType);
	if (size > 0) {
		int status = client.ReadArea(area, db, offset, size, S7WLByte, (void *)buffer);
		if (status == 0) {
			Variant val = GetValueFromBuffer(dataType, offset, bit);
			return val;
		} else {
			UtilityFunctions::print("failed to read with error: ", status);
		}
	}
	return Variant();
}

int Snap7Wrapper::GetDataSize(DATA_TYPE dt) {
	switch (dt) {
		case Snap7Wrapper::BOOL:
			return 1;
		case Snap7Wrapper::INT:
		case Snap7Wrapper::WORD:
			return 2;
		case Snap7Wrapper::REAL:
			return 4;
		default:
			break;
	}
	return -1;
}

Variant Snap7Wrapper::GetValueFromBuffer(DATA_TYPE dt, int offset, int bit) {
	switch (dt) {
		case Snap7Wrapper::BOOL:
		{
			bool xVal = (buffer[0] >> bit) & 1;
			return xVal;
		}
		case Snap7Wrapper::INT:
		case Snap7Wrapper::WORD:
			{
			int iVal = (buffer[0] << 8) | buffer[1];	
			return iVal;
			}
		case Snap7Wrapper::REAL:
			{
			float fVal;
			uint32_t tmp =
					(uint32_t(buffer[0]) << 24) |
					(uint32_t(buffer[1]) << 16) |
					(uint32_t(buffer[2]) << 8)	|
					(uint32_t(buffer[3]));

			std::memcpy(&fVal, &tmp, sizeof(fVal));
			return fVal;
			}
		default:
			break;
	}
	return Variant();
}

void Snap7Wrapper::SetPollRate(float val) {
	pollRate = val;
}

float Snap7Wrapper::GetPollRate() {
	return pollRate;
}

void Snap7Wrapper::SetAnalogMax(int val) {
	analogValueMax = val;
}

int Snap7Wrapper::GetAnalogMax() {
	return analogValueMax;
}

void Snap7Wrapper::SetIp(String ip) {
	ipAddress = ip;
}

String Snap7Wrapper::GetIp(){
	return ipAddress;
}

void Snap7Wrapper::Test() {
	UtilityFunctions::print("hello from c++. snap7 version! check for correct version (next time) ARGH");
}

uint32_t Snap7Wrapper::swapEndianF(float val) {
	union {
		float f;
		uint32_t u;
	}temp;
	temp.f = val;
	return _byteswap_ulong(temp.u);
}

void Snap7Wrapper::_bind_methods() {
	// ===== Methods =====
	ClassDB::bind_method(D_METHOD("ConnectToPLC", "ip", "rack", "slot"), &Snap7Wrapper::ConnectToPLC);
	ClassDB::bind_method(D_METHOD("IsConnected"), &Snap7Wrapper::IsConnected);
	ClassDB::bind_method(D_METHOD("WritePlc", "area", "data_type", "db", "offset", "bit", "value"), &Snap7Wrapper::WritePlc);
	ClassDB::bind_method(D_METHOD("ReadPlc", "area", "data_type", "db", "offset", "bit"), &Snap7Wrapper::ReadPlc);
	ClassDB::bind_method(D_METHOD("GetDataSize", "data_type"), &Snap7Wrapper::GetDataSize);
	ClassDB::bind_method(D_METHOD("GetValueFromBuffer", "data_type", "offset", "bit"), &Snap7Wrapper::GetValueFromBuffer);
	ClassDB::bind_method(D_METHOD("SetPollRate", "val"), &Snap7Wrapper::SetPollRate);
	ClassDB::bind_method(D_METHOD("GetPollRate"), &Snap7Wrapper::GetPollRate);
	ClassDB::bind_method(D_METHOD("SetAnalogMax", "val"), &Snap7Wrapper::SetAnalogMax);
	ClassDB::bind_method(D_METHOD("GetAnalogMax"), &Snap7Wrapper::GetAnalogMax);
	ClassDB::bind_method(D_METHOD("SetIp", "ip"), &Snap7Wrapper::SetIp);
	ClassDB::bind_method(D_METHOD("GetIp"), &Snap7Wrapper::GetIp);
	ClassDB::bind_method(D_METHOD("Test"), &Snap7Wrapper::Test);

	// ===== Properties =====
	ClassDB::add_property("Snap7Wrapper",
			PropertyInfo(Variant::FLOAT, "pollRate"),
			"SetPollRate", "GetPollRate");

	ClassDB::add_property("Snap7Wrapper",
			PropertyInfo(Variant::INT, "analogValueMax"),
			"SetAnalogMax", "GetAnalogMax");

	ClassDB::add_property("Snap7Wrapper",
			PropertyInfo(Variant::STRING, "ipAddress"),
			"SetIp", "GetIp");

	// ===== Enums =====
	BIND_ENUM_CONSTANT(BOOL);
	BIND_ENUM_CONSTANT(INT);
	BIND_ENUM_CONSTANT(WORD);
	BIND_ENUM_CONSTANT(REAL);

	BIND_ENUM_CONSTANT(INPUT_DONT_USE);
	BIND_ENUM_CONSTANT(OUTPUT);
	BIND_ENUM_CONSTANT(M_MEM);
	BIND_ENUM_CONSTANT(DATA_BLOCK);
	BIND_ENUM_CONSTANT(COUNTER_NYI);
	BIND_ENUM_CONSTANT(TIMER_NYI);
}
