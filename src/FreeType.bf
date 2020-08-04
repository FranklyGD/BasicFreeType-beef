using System;

namespace FreeType {
	public static class FT {
		struct Library : int {}
		public typealias Face = FaceRec*;

		[CRepr]
		public struct FaceRec {
			public int32 numberOfFaces;
			public int32 faceIndex;
			
			public int32 faceFlags;
			public int32 styleFlags;
			
			public int32 numberOfGlyphs;
			
			public char8* familyName;
			public char8* styleName;

			public int16 numberOfFixedSizes;
			public BitmapSize* availableSizes;
			
			public int16 numberOfCharacterMaps;
			public void* characterMaps;

			Generic generic;

			public BBox bbox;

			public uint16 unitsPerEM;
			public int16 ascender;
			public int16 descender;
			public int16 height;
			
			public int16 advanceWidth;
			public int16 advanceHeight;

			public int16 underlinePosition;
			public int16 underlineThickness;

			public GlyphSlot glyph;
			public void* size;
			public void* characterMap;

			void* driver;
			void* memory;
			void* stream;

			ListRec sizesList;

			Generic autoHint;
			void* extensions;

			void* @internal;
		}

		public typealias GlyphSlot = GlyphSlotRec*;
		[CRepr]
		public struct GlyphSlotRec {
		  Library library;
		  public Face face;
		  public GlyphSlot next;
		  public uint32 glyphIndex; 
		  Generic generic;

		  public GlyphMetrics metrics;
		  public int32 linearHorizontalAdvance;
		  public int32 linearVerticalAdvance;
		  public Vector advance;

		  public uint32 format;

		  public Bitmap bitmap;
		  public int32 bitmapLeft;
		  public int32 bitmapTop;

		  public Outline outline;

		  public uint16 numberOfSubglyphs;
		  void* subglyphs;

		  void* controlData;
		  int32 controlLength;

		  int32 lsb_delta;
		  int32 rsb_delta;

		  void* other;

		  void* @internal;
		}

		[CRepr]
		public struct GlyphMetrics {
			public int32 width;
			public int32 height;
			
			public int32 horizontalBearingX;
			public int32 horizontalBearingY;
			public int32 horizontalAdvance;
			
			public int32 verticalBearingX;
			public int32 verticalBearingY;
			public int32 verticalAdvance;
		}

		[CRepr]
		public struct Bitmap {
			public uint32 rows;
			public uint32 width;
			public int pitch;
			public uint8* buffer;
			public uint16 numberOfGrays;
			public uint8 pixelMode;
			public uint8 paletteMode;
			public void* palette;
		}

		[CRepr]
		public struct Outline {
		  int16 numberOfContours;
		  int16 numberOfPoints;

		  Vector* points;
		  uint8* tags;
		  int16* contours;

		  int16 flags;
		}

		[CRepr]
		public struct Vector {
			public int32 x,y;
		}

		[CRepr]
		public struct BitmapSize {
			public int16 height;
			public int16 width;
			
			public int64 size;
			
			public int64 xppem;
			public int64 yppem;
		}

		[CRepr]
		struct Generic {
			void* data;
			void* finalizer;
		}

		[CRepr]
		public struct BBox {
			public int32 xMin, yMin;
			public int32 xMax, yMax;
		}

		[CRepr]
		struct ListRec {
			void* head;
			void* tail;
		}

		public enum LoadFlag : int32 {
			Default = 0,
			NoScale = 1,
			NoHinting = 2,
			Render = 4,
			NoBitmap = 8,
		}

		static Library ft_library ~ Done(_);
		[LinkName("FT_Init_FreeType")]
		static extern bool Init(Library* library);
		public static void Init() {
			if (Init(&ft_library)) {
				System.Diagnostics.Debug.FatalError("FreeType could not initialize");
			}
		}

		[LinkName("FT_Done_FreeType")]
		static extern bool Done(Library library);

		[LinkName("FT_New_Face")]
		static extern bool NewFace(Library library, char8* path, int32 face_index, Face* aface);
		public static bool NewFace(char8* path, int32 face_index, Face* aface) {
			return NewFace(ft_library, path, face_index, aface);
		}

		[LinkName("FT_Set_Pixel_Sizes")]
		public static extern bool SetPixelSizes(Face face, uint32 width, uint32 height);

		[LinkName("FT_Load_Char")]
		public static extern bool LoadCharacter(Face face, char32 character, LoadFlag loadFlags);
		
		[LinkName("FT_Done_Face")]
		public static extern bool DoneFace(Face face);
	}
}
