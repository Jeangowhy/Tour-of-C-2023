#ifdef __cplusplus
// #waring "🔫 C++ extern C"
extern "C" {
#endif
    
__declspec(dllexport)
const char* world()
{
    return "world!\n";
}
    
#ifdef __cplusplus
}
#endif

