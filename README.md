isometric_rpg/
├── .loveignore
├── main.lua
├── conf.lua
├── README.md
├── docs/
│   └── design-docs.md
├── src/
│   ├── core/
│   │   ├── game_state.lua       -- Gerenciador de estados do jogo
│   │   ├── config.lua           -- Configurações globais
│   │   ├── event_system.lua     -- Sistema de eventos/pub-sub
│   │   └── utils.lua            -- Funções utilitárias
│   │
│   ├── game/
│   │   ├── entities/
│   │   │   ├── player.lua       -- Classe do jogador
│   │   │   ├── npcs/           -- NPCs específicos
│   │   │   └── enemies/        -- Inimigos diferentes
│   │   │
│   │   ├── world/
│   │   │   ├── map_loader.lua   -- Carregador de mapas
│   │   │   ├── tiles/          -- Definições de tiles
│   │   │   └── physics.lua      -- Sistema de colisão
│   │   │
│   │   ├── scenes/
│   │   │   ├── act_1/          -- Conteúdo específico do Ato 1
│   │   │   ├── village_scene.lua -- Cenas específicas
│   │   │   └── dungeon_scene.lua
│   │   │
│   │   ├── systems/
│   │   │   ├── combat.lua       -- Sistema de combate
│   │   │   ├── magic.lua        -- Sistema de magia
│   │   │   ├── crafting.lua     -- Sistema de craft
│   │   │   └── quests.lua       -- Gerenciador de missões
│   │   │
│   │   └── services/
│   │       ├── localization.lua -- Internacionalização
│   │       ├── save_system.lua  -- Sistema de save/load
│   │       └── audio.lua        -- Gerenciador de áudio
│   │
│   └── ui/
│       ├── hud/
│       │   ├── inventory_hud.lua
│       │   ├── quest_hud.lua
│       │   └── minimap.lua
│       │
│       ├── menus/
│       │   ├── main_menu.lua
│       │   ├── pause_menu.lua
│       │   └── settings.lua
│       │
│       └── widgets/
│           ├── dialog_box.lua
│           └── tooltips.lua
│
├── assets/
│   ├── graphics/
│   │   ├── tilesets/
│   │   ├── sprites/
│   │   ├── ui/
│   │   └── effects/
│   │
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   │
│   ├── fonts/
│   └── localization/
│       ├── en_US.lua
│       └── pt_BR.lua
│
├── lib/
│   ├── hump/                  -- Biblioteca útil para gamestates
│   ├── bump.lua               -- Para colisões
│   └── ...                    -- Outras libs
│
└── tests/                     -- (Opcional) Testes unitários
