/******************************************************************************

 @File         PVRTHash.h

 @Title        PVRTHash

 @Version      

 @Copyright    Copyright (c) Imagination Technologies Limited.

 @Platform     All

 @Description  A simple hash class which uses TEA to hash a string or given  data
               in to a 32-bit unsigned int.

******************************************************************************/

#ifndef PVRTHASH_H
#define PVRTHASH_H

#include "PVRTString.h"

/*!****************************************************************************
Class CPVRTHash
******************************************************************************/
class CPVRTHash
{
public:
	/*!***************************************************************************
	@Function		CPVRTHash
	@Description	Constructor
	*****************************************************************************/
	CPVRTHash() : m_uiHash(0) {}

	/*!***************************************************************************
	@Function		CPVRTHash
	@Input			rhs
	@Description	Copy Constructor
	*****************************************************************************/
	CPVRTHash(const CPVRTHash& rhs) : m_uiHash(rhs.m_uiHash) {}

	/*!***************************************************************************
	@Function		CPVRTHash
	@Input			String
	@Description	Overloaded constructor
	*****************************************************************************/
	CPVRTHash(const CPVRTString& String)
	{
		m_uiHash = MakeHash(String);
	}

	/*!***************************************************************************
	@Function		CPVRTHash
	@Input			c_pszString
	@Description	Overloaded constructor
	*****************************************************************************/
	CPVRTHash(const char* c_pszString)
	{
		m_uiHash = MakeHash(c_pszString);
	}

	/*!***************************************************************************
	@Function		CPVRTHash
	@Input			pData
	@Input			dataSize
	@Input			dataCount
	@Description	Overloaded constructor
	*****************************************************************************/
	CPVRTHash(const void* pData, unsigned int dataSize, unsigned int dataCount)
	{
		m_uiHash = MakeHash(pData, dataSize, dataCount);
	}

	/*!***************************************************************************
	@Function		operator=
	@Input			rhs
	@Return			CPVRTHash &	
	@Description	Overloaded assignment.
	*****************************************************************************/
	CPVRTHash& operator=(const CPVRTHash& rhs)
	{
		if(this != &rhs)
		{
			m_uiHash = rhs.m_uiHash;
		}

		return *this;
	}

	/*!***************************************************************************
	@Function		operator unsigned int
	@Return			int	
	@Description	Converts to unsigned int.
	*****************************************************************************/
	operator unsigned int() const
	{
		return m_uiHash;
	}

	/*!***************************************************************************
	@Function		MakeHash
	@Input			String
	@Return			unsigned int			The hash.
	@Description	Generates a hash from a CPVRTString.
	*****************************************************************************/
	static CPVRTHash MakeHash(const CPVRTString& String)
	{
		return MakeHash(String.c_str(), sizeof(char), (unsigned int) String.length());
	}

	/*!***************************************************************************
	@Function		MakeHash
	@Input			c_pszString
	@Return			unsigned int			The hash.
	@Description	Generates a hash from a null terminated char array.
	*****************************************************************************/
	static CPVRTHash MakeHash(const char* c_pszString)
	{
		const char* pCursor = c_pszString;
		while(*pCursor) pCursor++;
		return MakeHash(c_pszString, sizeof(char), (unsigned int) (pCursor - c_pszString));
	}
		
	/*!***************************************************************************
	@Function		MakeHash
	@Input			pData
	@Input			dataSize
	@Input			dataCount
	@Return			unsigned int			The hash.
	@Description	Generates a hash from generic data.
	*****************************************************************************/
	static CPVRTHash MakeHash(const void* pData, unsigned int dataSize, unsigned int dataCount)
	{
		if(!pData || dataSize == 0 || dataCount == 0)
			return 0;

		CPVRTHash pvrHash;
		char  cKey[16] = "6936512HJEHS234";					// A random key
		unsigned int Hash[2] = {0,0};
		unsigned int uiIndex = 0;

		const unsigned char* pu8Data = (unsigned char*)pData;
		while(uiIndex < dataSize * dataCount)
		{
			cKey[uiIndex & 15] += pu8Data[uiIndex];
			++uiIndex;
			if((uiIndex & 15) == 0)
				Encipher(Hash, (unsigned int*)cKey);
		}

		if(uiIndex & 15)
			Encipher(Hash, (unsigned int*)cKey);

		pvrHash.m_uiHash = Hash[0] + Hash[1];
		return pvrHash;
	}

private:
	/*!***************************************************************************
	@Function		Encipher
	@Output			pHash
	@Input			pKey
	@Description	Performs the encryption.
	*****************************************************************************/
	static void Encipher(unsigned int* pHash, const unsigned int* pKey)
	{
		unsigned int v0 = pHash[0], v1 = pHash[1];
		unsigned int delta = 0x9E3779B9;
		unsigned int sum   = 0;

		for(unsigned int uiIndex = 0; uiIndex < 32; ++uiIndex)
		{
			v0 += (v1 << 4 ^ v1 >> 5) + v1 ^ sum + pKey[sum & 3];
			sum += delta;
			v1 += (v0 << 4 ^ v0 >> 5) + v0 ^ sum + pKey[sum >> 11 & 3];
		}

		pHash[0] = v0;
		pHash[1] = v1;
	}

private:
	unsigned int		m_uiHash;		/// The hashed data.
};

#endif

