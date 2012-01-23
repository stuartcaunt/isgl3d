/******************************************************************************

 @File         PVRTArray.h

 @Title        PVRTArray

 @Version      

 @Copyright    Copyright (c) Imagination Technologies Limited.

 @Platform     ANSI compatible

 @Description  Expanding array template class. Allows appending and direct
               access. Mixing access methods should be approached with caution.

******************************************************************************/
#ifndef __PVRTARRAY_H__
#define __PVRTARRAY_H__

#include "PVRTGlobal.h"

/*!****************************************************************************
Class
******************************************************************************/

/*!***************************************************************************
* @Class CPVRTArray
* @Brief Expanding array template class.
* @Description Expanding array template class.
*****************************************************************************/
template<typename T>
class CPVRTArray
{
public:
	/*!***************************************************************************
	@Function			CPVRTArray
	@Description		Blank constructor. Makes a default sized array.
	*****************************************************************************/
	CPVRTArray() : m_i32Size(0), m_i32Capacity(GetDefaultSize())
	{
		m_pArray = new T[m_i32Capacity];
	}

	/*!***************************************************************************
	@Function			CPVRTArray
	@Input				i32Size	intial size of array
	@Description		Constructor taking initial size of array in elements.
	*****************************************************************************/
	CPVRTArray(const int i32Size) : m_i32Size(0), m_i32Capacity(i32Size)
	{
		_ASSERT(i32Size!=0);
		m_pArray = new T[i32Size];
	}

	/*!***************************************************************************
	@Function			CPVRTArray
	@Input				original	the other dynamic array
	@Description		Copy constructor.
	*****************************************************************************/
	CPVRTArray(const CPVRTArray& original) : m_i32Size(original.m_i32Size),
											  m_i32Capacity(original.m_i32Capacity)
	{
		m_pArray = new T[m_i32Capacity];
		for(int i=0;i<m_i32Size;i++)
		{
			m_pArray[i]=original.m_pArray[i];
		}
	}

	/*!***************************************************************************
	@Function			CPVRTArray
	@Input				pArray		an ordinary array
	@Input				i32Size		number of elements passed
	@Description		constructor from ordinary array.
	*****************************************************************************/
	CPVRTArray(const T* const pArray, const int i32Size) : m_i32Size(i32Size),
														  m_i32Capacity(i32Size)
	{
		m_pArray = new T[i32Size];
		// Copy old values to new array
		for(int i=0;i<m_i32Size;i++)
		{
			m_pArray[i]=pArray[i];
		}
	}

	/*!***************************************************************************
	@Function			~CPVRTArray
	@Description		Destructor.
	*****************************************************************************/
	virtual ~CPVRTArray()
	{
		if(m_pArray)
			delete [] m_pArray;
	}

	/*!***************************************************************************
	@Function			Append
	@Input				addT	The element to append
	@Description		Appends an element to the end of the array, expanding it
						if necessary.
	*****************************************************************************/
	int Append(const T& addT)
	{
		int i32Index = Append();
		m_pArray[i32Index] = addT;
		return i32Index;
	}

	/*!***************************************************************************
	@Function			Append
	@Return				unsigned int	The index of the new item.
	@Description		Creates space for a new item, but doesn't add. Instead
						returns the index of the new item.
	*****************************************************************************/
	int Append()
	{
		int i32Index = m_i32Size;
		SetCapacity(++m_i32Size);
		return i32Index;
	}

	/*!***************************************************************************
	@Function			SetSize
	@Input				i32Size		New capacity of array
	@Description		Expands array to new capacity
	*****************************************************************************/
	bool SetCapacity(const int i32Size)
	{
		if(i32Size <= m_i32Capacity)
			return true;	// nothing to be done

		int i32NewCapacity = 0;
		if(i32Size < m_i32Capacity<<1)
			i32NewCapacity = m_i32Capacity<<1;		// Ignore the new size. Expand to twice the previous size.
		else
			i32NewCapacity = i32Size;

		T* pOldArray = m_pArray;
		T* pNewArray = new T[i32NewCapacity];		// New Array

		if(!pNewArray)
			return false;							// Failed to allocate memory!

		// Copy source data to new array
		for(int i = 0; i < m_i32Size; ++i)
		{
			pNewArray[i] = m_pArray[i];
		}

		// Switch pointers and free memory
		m_i32Capacity	= i32NewCapacity;
		m_pArray		= pNewArray;
		delete [] pOldArray;
		return true;
	}

	/*!***************************************************************************
	@Function			Copy
	@Input				other	The CPVRTArray needing copied
	@Description		A copy function. Will attempt to copy from other CPVRTArrays
						if this is possible.
	*****************************************************************************/
	template<typename T2>
	void Copy(const CPVRTArray<T2>& other)
	{
		T* pNewArray = new T[other.GetCapacity()];
		if(pNewArray)
		{
			// Copy data
			for(int i = 0; i < other.GetSize(); i++)
			{
				pNewArray[i] = other[i];
			}

			// Free current array
			if(m_pArray)
				delete [] m_pArray;

			// Swap pointers
			m_pArray		= pNewArray;

			m_i32Capacity	= other.GetCapacity();
			m_i32Size		= other.GetSize();
		}
	}

	/*!***************************************************************************
	@Function			=
	@Input				other	The CPVRTArray needing copied
	@Description		assignment operator.
	*****************************************************************************/
	CPVRTArray& operator=(const CPVRTArray<T>& other)
	{
		if(&other != this)
			Copy(other);

		return *this;
	}

	/*!***************************************************************************
	@Function			[]
	@Input				i32Index	index of element in array
	@Return				the element indexed
	@Description		indexed access into array. Note that this has no error
						checking whatsoever
	*****************************************************************************/
	T& operator[](const int i32Index)
	{
		_ASSERT(i32Index < m_i32Capacity);
		return m_pArray[i32Index];
	}

	/*!***************************************************************************
	@Function			[]
	@Input				i32Index	index of element in array
	@Return				The element indexed
	@Description		Indexed access into array. Note that this has no error
						checking whatsoever
	*****************************************************************************/
	const T& operator[](const int i32Index) const
	{
		_ASSERT(i32Index < m_i32Capacity);
		return m_pArray[i32Index];
	}

	/*!***************************************************************************
	@Function			GetSize
	@Return				Size of array
	@Description		Gives current size of array/number of elements
	*****************************************************************************/
	int GetSize() const
	{
		return m_i32Size;
	}

	/*!***************************************************************************
	@Function			GetDefaultSize
	@Return				Default size of array
	@Description		Gives the default size of array/number of elements
	*****************************************************************************/
	static int GetDefaultSize()
	{
		return 16;
	}

	/*!***************************************************************************
	@Function			GetCapacity
	@Return				Capacity of array
	@Description		Gives current allocated size of array/number of elements
	*****************************************************************************/
	int GetCapacity() const
	{
		return m_i32Capacity;
	}

	/*!***************************************************************************
	@Function			Sort
	@Return				void
	@Description		Simple bubble-sort of the array. Pred should be an object that
						defines a bool operator().
	*****************************************************************************/
	template<class Pred>
	void Sort(Pred predicate)
	{
		bool bSwap;
		for(int i=0; i < m_i32Size; ++i)
		{
			bSwap = false;
			for(int j=0; j < m_i32Size-1; ++j)
			{
				if(predicate(m_pArray[j], m_pArray[j+1]))
				{
					PVRTswap(m_pArray[j], m_pArray[j+1]);
					bSwap = true;
				}
			}

			if(!bSwap)
				return;
		}
	}

	/*!***************************************************************************
	@Function			RemoveLast
	@Description		Removes the last element. Simply decrements the size value
	*****************************************************************************/
	virtual void RemoveLast()
	{
		if(m_i32Size > 0)
			m_i32Size--;
	}

protected:
	int 	m_i32Size;				/*! current size of contents of array */
	int		m_i32Capacity;			/*! currently allocated size of array */
	T		*m_pArray;				/*! the actual array itself */
};

// note "this" is required for ISO standard C++ and gcc complains otherwise
// http://lists.apple.com/archives/Xcode-users//2005/Dec/msg00644.html
template<typename T>
class CPVRTArrayManagedPointers : public CPVRTArray<T*>
{
public:
	virtual ~CPVRTArrayManagedPointers()
	{
		if(this->m_pArray)
		{
			for(int i=0;i<this->m_i32Size;i++)
			{
				delete(this->m_pArray[i]);
			}
		}
	}

	virtual void RemoveLast()
	{
		if(this->m_i32Size > 0 && this->m_pArray)
		{
			delete this->m_pArray[this->m_i32Size-1];
			this->m_i32Size--;
		}
	}
};

#endif // __PVRTARRAY_H__

/*****************************************************************************
End of file (PVRTArray.h)
*****************************************************************************/

