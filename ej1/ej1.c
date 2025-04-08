#include "ej1.h"

/**
 * Crea una lista doblemente enlazada vacía.
 */
string_proc_list* string_proc_list_create(void){
    // Reservamos memoria para la lista
    string_proc_list* list = (string_proc_list*)malloc(sizeof(string_proc_list));
    // Inicializamos punteros
    list->first = NULL;
    list->last  = NULL;
    return list;
}

/**
 * Crea un nodo con el type y hash indicados.
 * El nodo NO copia la cadena, sino que la apunta directamente.
 */
string_proc_node* string_proc_node_create(uint8_t type, char* hash){
    // Reservamos memoria para el nodo
    string_proc_node* node = (string_proc_node*)malloc(sizeof(string_proc_node));
    // Asignamos los valores de type y hash
    node->type = type;
    node->hash = hash;
    // Inicializamos punteros a nodos adyacentes
    node->next = NULL;
    node->previous = NULL;
    return node;
}

/**
 * Agrega un nodo al final de la lista, con el type y hash especificados.
 * No se copia la cadena hash, sino que el nodo apunta directamente a ella.
 */
void string_proc_list_add_node(string_proc_list* list, uint8_t type, char* hash){
    // Creamos el nodo
    string_proc_node* new_node = string_proc_node_create(type, hash);

    // Si la lista está vacía, first y last apuntarán a este nuevo nodo
    if(list->first == NULL){
        list->first = new_node;
        list->last  = new_node;
    }
    else{
        // Enlazamos el último nodo con el nuevo
        list->last->next = new_node;
        new_node->previous = list->last;
        // Actualizamos el puntero last
        list->last = new_node;
    }
}

/**
 * Concatena en un string nuevo (reservado con malloc) el 'hash' dado por parámetro
 * y todos los hashes de los nodos cuyo type coincida con el indicado.
 * Retorna la nueva cadena concatenada.
 * 
 * Ejemplo:
 *    char* result = string_proc_list_concat(list, 3, "inicio:");
 *    // result podría terminar siendo "inicio:nodoHash1nodoHash2..."
 */
char* string_proc_list_concat(string_proc_list* list, uint8_t type , char* hash){
    // Empezamos con una copia del hash base
    // (str_concat("", hash) produce una copia de 'hash' en la variable 'result')
    char* result = str_concat("", hash);

    // Recorremos la lista
    string_proc_node* current = list->first;
    while(current != NULL){
        // Si el tipo coincide, concatenamos su hash
        if(current->type == type){
            // Guardamos el antiguo result para poder liberarlo
            char* old_result = result;
            result = str_concat(result, current->hash);
            free(old_result);  // Liberamos la cadena anterior para evitar fugas
        }
        current = current->next;
    }

    // Devolvemos la nueva cadena con la concatenación
    return result;
}


/** AUX FUNCTIONS **/

void string_proc_list_destroy(string_proc_list* list){

	/* borro los nodos: */
	string_proc_node* current_node	= list->first;
	string_proc_node* next_node		= NULL;
	while(current_node != NULL){
		next_node = current_node->next;
		string_proc_node_destroy(current_node);
		current_node	= next_node;
	}
	/*borro la lista:*/
	list->first = NULL;
	list->last  = NULL;
	free(list);
}
void string_proc_node_destroy(string_proc_node* node){
	node->next      = NULL;
	node->previous	= NULL;
	node->hash		= NULL;
	node->type      = 0;			
	free(node);
}

char* str_concat(char* a, char* b) {
	int len1 = strlen(a);
    int len2 = strlen(b);
	int totalLength = len1 + len2;
    char *result = (char *)malloc(totalLength + 1); 
    strcpy(result, a);
    strcat(result, b);
    return result;  
}

void string_proc_list_print(string_proc_list* list, FILE* file){
        uint32_t length = 0;
        string_proc_node* current_node  = list->first;
        while(current_node != NULL){
                length++;
                current_node = current_node->next;
        }
        fprintf( file, "List length: %d\n", length );
		current_node    = list->first;
        while(current_node != NULL){
                fprintf(file, "\tnode hash: %s | type: %d\n", current_node->hash, current_node->type);
                current_node = current_node->next;
        }
}

